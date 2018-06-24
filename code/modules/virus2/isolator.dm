// UI menu navigation
#define HOME "home"
#define LIST "list"
#define ENTRY "entry"

/obj/machinery/disease2/isolator/
	name = "pathogenic isolator"
	density = 1
	anchored = 1
	icon = 'icons/obj/virology.dmi'
	icon_state = "isolator"
	var/isolating = 0
	var/state = HOME
	var/datum/disease2/disease/virus2 = null
	var/datum/data/record/entry = null
	var/obj/item/weapon/reagent_containers/syringe/sample = null

/obj/machinery/disease2/isolator/update_icon()
	if (stat & (BROKEN|NOPOWER))
		icon_state = "isolator"
		return

	if (isolating)
		icon_state = "isolator_processing"
	else if (sample)
		icon_state = "isolator_in"
	else
		icon_state = "isolator"

/obj/machinery/disease2/isolator/attackby(var/obj/O as obj, var/mob/user)
	if(!istype(O,/obj/item/weapon/reagent_containers/syringe)) return
	var/obj/item/weapon/reagent_containers/syringe/S = O

	if(sample)
		user << "\The [src] is already loaded."
		return

	sample = S
	user.drop_item()
	S.forceMove(src)

	user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
	SSnanoui.update_uis(src)
	update_icon()

	src.attack_hand(user)

/obj/machinery/disease2/isolator/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN)) return
	ui_interact(user)

/obj/machinery/disease2/isolator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["syringe_inserted"] = !!sample
	data["isolating"] = isolating
	data["pathogen_pool"] = null
	data["state"] = state
	data["entry"] = entry
	data["can_print"] = (state != HOME || sample) && !isolating

	switch (state)
		if (HOME)
			if (sample)
				var/list/pathogen_pool[0]
				for(var/datum/reagent/blood/B in sample.reagents.reagent_list)
					var/list/virus = B.data["virus2"]
					for (var/ID in virus)
						var/datum/disease2/disease/V = virus[ID]
						var/datum/data/record/R = null
						if (ID in virusDB)
							R = virusDB[ID]
		
						var/datum/weakref/A = B.data["donor"]
						var/mob/living/carbon/human/D = A.resolve()
						pathogen_pool.Add(list(list(\
							"name" = "[D ? D.get_species() : "unknown"] [B.name]", \
							"dna" = B.data["blood_DNA"], \
							"unique_id" = V.uniqueID, \
							"reference" = "\ref[V]", \
							"is_in_database" = !!R, \
							"record" = "\ref[R]")))

				if (pathogen_pool.len > 0)
					data["pathogen_pool"] = pathogen_pool

		if (LIST)
			var/list/db[0]
			for (var/ID in virusDB)
				var/datum/data/record/r = virusDB[ID]
				db.Add(list(list("name" = r.fields["name"], "record" = "\ref[r]")))

			if (db.len > 0)
				data["database"] = db

		if (ENTRY)
			if (entry)
				var/desc = entry.fields["description"]
				data["entry"] = list(\
					"name" = entry.fields["name"], \
					"description" = replacetext(desc, "\n", ""))

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "pathogenic_isolator.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/disease2/isolator/machinery_process()
	if (isolating > 0)
		isolating -= 1
		if (isolating == 0)
			if (virus2)
				var/obj/item/weapon/virusdish/d = new /obj/item/weapon/virusdish(src.loc)
				d.virus2 = virus2.getcopy()
				virus2 = null
				ping("\The [src] pings, \"Viral strain isolated.\"")

			SSnanoui.update_uis(src)
			update_icon()

/obj/machinery/disease2/isolator/Topic(href, href_list)
	if (..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if (href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if (href_list[HOME])
		state = HOME
		return 1

	if (href_list[LIST])
		state = LIST
		return 1

	if (href_list[ENTRY])
		if (istype(locate(href_list["view"]), /datum/data/record))
			entry = locate(href_list["view"])

		state = ENTRY
		return 1

	if (href_list["print"])
		do_print(user)
		return 1

	if(!sample) return 1

	if (href_list["isolate"])
		var/datum/disease2/disease/V = locate(href_list["isolate"])
		if (V)
			virus2 = V
			isolating = 20
			update_icon()
		return 1

	if (href_list["eject"])
		sample.forceMove(src.loc)
		sample = null
		update_icon()
		return 1

/obj/machinery/disease2/isolator/proc/do_print(var/mob/user)
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(loc)
	var/pname
	var/info = ""

	switch (state)
		if (HOME)
			if (!sample) return
			pname = "paper - Patient Diagnostic Report"
			info = {"
				[virology_letterhead("Patient Diagnostic Report")]
				<center><small><font color='red'><b>CONFIDENTIAL MEDICAL REPORT</b></font></small></center><br>
				<large><u>Sample:</u></large> [sample.name]<br>
"}

			if (user)
				info += "<u>Generated By:</u> [user.name]<br>"

			info += "<hr>"

			for(var/datum/reagent/blood/B in sample.reagents.reagent_list)
				var/datum/weakref/A = B.data["donor"]
				var/mob/living/carbon/human/D = A.resolve()
				info += "<large><u>[D ? D.get_species() : "unknown"] [B.name]:</u></large><br>[B.data["blood_DNA"]]<br>"

				var/list/virus = B.data["virus2"]
				info += "<u>Pathogens:</u> <br>"
				if (virus.len > 0)
					for (var/ID in virus)
						var/datum/disease2/disease/V = virus[ID]
						info += "[V.name()]<br>"
				else
					info += "None<br>"

			info += {"
			<hr>
			<u>Additional Notes:</u>&nbsp;
"}

		if (LIST)
			pname = "paper - Virus List"
			info = {"
				[virology_letterhead("Virus List")]
"}

			var/i = 0
			for (var/ID in virusDB)
				i++
				var/datum/data/record/r = virusDB[ID]
				info += "[i]. " + r.fields["name"]
				info += "<br>"

			info += {"
			<hr>
			<u>Additional Notes:</u>&nbsp;
"}

		if (ENTRY)
			pname = "paper - Viral Profile"
			info = {"
				[virology_letterhead("Viral Profile")]
				[entry.fields["description"]]
				<hr>
				<u>Additional Notes:</u>&nbsp;
"}

	P.set_content_unsafe(pname, info)
	print(P)
