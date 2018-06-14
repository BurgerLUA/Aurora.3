// Regular airbubble - folded
/obj/item/airbubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/airbubble.dmi'
	icon_state = "airbubble_fact_folded"
	w_class = ITEMSIZE_NORMAL
	var/used = FALSE
	var/ripped = FALSE
	var/zipped = FALSE
	var/obj/item/weapon/tank/internal_tank
	var/syndie = FALSE

/obj/item/airbubble/Destroy()
	qdel(internal_tank)
	return ..()

// Deploy the bubble and transfer all properties of it
/obj/item/airbubble/attack_self(mob/user)
	if (!isturf(user.loc))
		to_chat(user, "You're fucking stupid, the air bubble can't deploy in an enclosed space.")
		return
	var/obj/structure/closet/airbubble/R
	if(syndie)
		R = new /obj/structure/closet/airbubble/syndie(user.loc)
	else
		R = new /obj/structure/closet/airbubble(user.loc)
	if(!used && !ripped)
		internal_tank = new /obj/item/weapon/tank/emergency_oxygen/double(src)
	R.internal_tank = internal_tank
	internal_tank.forceMove(R)
	internal_tank = null
	R.add_fingerprint(user)
	R.ripped = ripped
	R.zipped = zipped
	R.update_icon()
	R.desc = desc
	user.drop_from_inventory(src)
	qdel(src)

// Deployed bubble
/obj/structure/closet/airbubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/airbubble.dmi'
	icon_state = "airbubble"
	icon_closed = "airbubble"
	icon_opened = "airbubble_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/airbubble
	var/zipped = FALSE
	density = 0
	storage_capacity = 20
	var/contains_body = FALSE
	var/used = TRUE // If we have deployed it once
	var/ripped = FALSE // If it has a hole it in, vent all the air outside
	var/breakout_time = 1 // How many minutes it takes to break out of it.

	var/use_internal_tank = TRUE
	var/datum/gas_mixture/inside_air
	var/internal_tank_valve = 45 // arbitrary for now
	var/obj/item/weapon/tank/internal_tank
	var/process_ticks = 0
	var/syndie = FALSE
	var/last_shake = 0

/obj/structure/closet/airbubble/can_open()
	if(zipped)
		return 0
	return 1

/obj/structure/closet/airbubble/can_close()
	if(zipped)
		return 0
	var/turf/T = get_turf(src)
	for (var/obj/O in T)
		if (O.density && O != src)
			return 0
	var/mob_num = 0
	for(var/mob/living/M in T)
		mob_num += 1
		if(mob_num > 1)
			user << "<span class='warning'>[src] can only fit one person.</span>"
			return 0
	return 1

/obj/structure/closet/airbubble/dump_contents()

	for(var/obj/I in src)
		if (I != internal_tank)
			I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/airbubble/Initialize()
	. = ..()
	add_inside()
	START_PROCESSING(SSfast_process, src)

/obj/structure/closet/airbubble/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	qdel(internal_tank)
	if(parts)
		new parts(loc)
	if (smooth)
		queue_smooth_neighbors(src)
	return ..()

/obj/structure/closet/airbubble/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	var/stored_units = 0

	if(store_misc)
		stored_units += store_misc(stored_units)
	if(store_items)
		stored_units += store_items(stored_units)
	if(store_mobs)
		stored_units += store_mobs(stored_units)

	icon_state = icon_closed
	opened = 0

	playsound(loc, close_sound, 25, 0, -3)
	density = 1
	add_inside()
	return 1

// Fold the bubble, transfering properties.
/obj/structure/closet/airbubble/MouseDrop(over_object, src_location, over_location)
	if((!zipped || ripped )&& (over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(opened)	return 0
		if(contents.len > 1)	return 0
		visible_message("[usr] folds up the [src.name]")
		var/obj/item/airbubble/bag
		if(syndie)
			bag = new /obj/item/airbubble/syndie(get_turf(src))
		else
			bag = new /obj/item/airbubble(get_turf(src))
		bag.ripped = ripped
		bag.zipped = zipped
		bag.internal_tank = internal_tank
		internal_tank.forceMove(bag)
		internal_tank = null
		bag.w_class = ITEMSIZE_LARGE

		bag.desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
		if(syndie)
			bag.desc += " This does not seem like a regular color scheme"
		bag.desc += " It appears to be poorly hand folded."

		if(ripped)
			bag.icon_state = "[icon_closed]_man_folded_ripped"
			bag.desc += " <span class='danger'>It has hole in it! Maybe you shouldn't use it!</span>"
		else
			bag.icon_state = "[icon_closed]_man_folded"
		qdel(src)
		return

/obj/structure/closet/airbubble/req_breakout()

	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if(zipped)
		return 1 // If it is zipped
	if(breakout)
		return -1 //Already breaking out.
	return 0

/obj/structure/closet/airbubble/proc/breakout_callback(var/mob/living/escapee)
	if (QDELETED(escapee))
		return FALSE

	if ((world.time - last_shake) > 5 SECONDS)
		playsound(loc, "sound/items/[pick("rip1","rip2")].ogg", 100, 1)
		animate_shake()
		last_shake = world.time

	if (!req_breakout())
		return FALSE

	return TRUE

// If we are stuck, and need to get out
/obj/structure/closet/airbubble/mob_breakout(var/mob/living/escapee)
	if (req_breakout() < 1)
		return

	escapee.next_move = world.time + 100
	escapee.last_special = world.time + 100
	escapee << "<span class='warning'>You lean on the back of \the [src] and start punching internal wall with your legs. (this will take about [breakout_time] minutes)</span>"
	visible_message("<span class='danger'>\The [src] begins to shake violently! Something is terring it from the inside!</span>")

	var/time = 360 * breakout_time * 2
	breakout = TRUE

	if (!do_after(escapee, time, act_target = src, extra_checks = CALLBACK(src, .proc/breakout_callback, escapee)))
		breakout = FALSE
		return

	breakout = FALSE
	escapee << "<span class='warning'>You successfully break out! Tearing the bubble's walls!</span>"
	visible_message("<span class='danger'>\the [escapee] successfully broke out of \the [src]! Tearing the bubble's walls!</span>")
	playsound(loc, "sound/items/[pick("rip1","rip2")].ogg", 100, 1)
	break_open()
	animate_shake()
	desc += " <span class='danger'>It has hole in it! Maybe you shouldn't use it!</span>"

// We are out finally, the bubble is ripped. So dump everything out from it. Especially air and user.
/obj/structure/closet/airbubble/break_open()
	ripped = TRUE
	update_icon()
	dump_contents()
	var/datum/gas_mixture/t_air = get_turf_air()
	t_air.merge(inside_air)

// Change valve on internal tank
/obj/structure/closet/airbubble/verb/set_internals()
	set src in oview(1)
	set category = "Object"
	set name = "Set Internals"
	if(!isnull(internal_tank))
		usr.visible_message(
		"<span class='warning'>[usr] is setting [src] internals.</span>",
		"<span class='notice'>You are settting [src] internals.</span>"
		)
		if (!do_after(usr, 2 SECONDS, act_target = src))
			return
		usr.visible_message(
		"<span class='warning'>[usr] has set [src] internals.</span>" ,
		"<span class='notice'>You set [src] internals.</span>"
		)
		if(use_internal_tank)
			STOP_PROCESSING(SSfast_process, src)
		else
			START_PROCESSING(SSfast_process, src)
		use_internal_tank = !use_internal_tank
	else
		usr << "<span class='notice'>[src] has no internal tank.</span>"

// Remove tank from bubble
/obj/structure/closet/airbubble/verb/take_tank()
	set src in oview(1)
	set category = "Object"
	set name = "Remove Air Tank"
	if(!isnull(internal_tank))
		usr.visible_message(
		"<span class='warning'>[usr] is removing [internal_tank] from [src].</span>",
		"<span class='notice'>You are removing [internal_tank] from [src].</span>"
		)
		if (!do_after(usr, 2 SECONDS, act_target = src))
			return
		usr.visible_message(
		"<span class='warning'>[usr] has removed [internal_tank] from [src].</span>",
		"<span class='notice'>You removed [internal_tank] from [src].</span>"
		)
		for(var/obj/I in src)
			I.forceMove(usr.loc)
		use_internal_tank = 0
		internal_tank = null
		update_icon()
		STOP_PROCESSING(SSfast_process, src)
	else
		usr << "<span class='warning'>[src] already has no tank.</span>"

// Handle most of things: restraining, cutting restrains, attaching tank.
/obj/structure/closet/airbubble/attackby(W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/tank))
		if(!use_internal_tank)
			user.visible_message(
			"<span class='warning'>[user] is attaching [W] to [src].</span>",
			"<span class='notice'>You are attaching [W] to [src].</span>"
			)
			if (!do_after(user, 2 SECONDS, act_target = src))
				return
			user.visible_message(
			"<span class='warning'>[user] has attached [W] to [src].</span>",
			"<span class='notice'>You attached [W] to [src].</span>"
			)
			var/obj/item/weapon/tank/T = W
			internal_tank = T
			user.drop_from_inventory(T)
			T.forceMove(src)
			use_internal_tank = 1
			START_PROCESSING(SSfast_process, src)
		else
			user << "<span class='warning'>[src] already has a tank attached.</span>"
	if(opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			MouseDrop_T(G.affecting, user)
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(!dropsafety(W))
			return
		user.drop_item()
	else if(istype(W, /obj/item/weapon/handcuffs/cable))
		user.visible_message(
		"<span class='warning'>[user] begins putting cable restrains on zipper of [src].</span>",
		"<span class='notice'>You begin putting cable restrains on zipper of [src].</span>"
		)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 50, 1)
		if (!do_after(user, 3 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
			return
		zipped = !zipped
		update_icon()
		user.visible_message(
		"<span class='warning'>[src]'s zipper have been zipped by [user].</span>",
		"<span class='notice'>You put restrains on [src]'s zipper.</span>"
		)

		qdel(W)
		update_icon()
	else if(istype(W, /obj/item/weapon/wirecutters))
		user.visible_message(
		"<span class='warning'>[user] begins cutting cable restrains on zipper of [src].</span>",
		"<span class='notice'>You begin cutting cable restrains on zipper of [src].</span>"
		)
		playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
		if (!do_after(user, 3 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
			return
		zipped = !zipped
		update_icon()
		user.visible_message(
		"<span class='warning'>[src] zipper's cable restrains has been cut by [user].</span>",
		"<span class='notice'>You cut cable restrains on [src]'s zipper.</span>"
		)
		new/obj/item/weapon/handcuffs/cable(src.loc)
		update_icon()
	else
		attack_hand(user)
	return

/obj/structure/closet/airbubble/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/airbubble/update_icon()
	cut_overlays()
	if(opened)
		icon_state = icon_opened
	else if(ripped)
		name = "ripped air bubble"
		icon_state = "[icon_closed]_ripped"
	else
		icon_state = icon_closed
	if(zipped)
		add_overlay("[icon_closed]_restrained")

// Process transfer of air from the tank. Handle if it is ripped open.
/obj/structure/closet/airbubble/proc/process_tank_give_air()
	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		// If ripped, we are leaking
		if(ripped)
			// If we has no pressure in the tank, why bother?
			if(tank_air.return_pressure() <= 1)
				STOP_PROCESSING(SSfast_process, src)
				use_internal_tank = !use_internal_tank
				visible_message("<span class='warning'>You hear last bits of air coming out from [src]'s hole.Maybe the tank run out of air?</span>")
				playsound(loc, "sound/effects/wind/wind_2_1.ogg", 100, 1)
				return
			inside_air = get_turf_air()
			visible_message("<span class='warning'>You hear air howling from [src]'s hole. Maybe it is good to shut off valve on the internals tank?</span>")
			playsound(loc, "sound/effects/wind/wind_2_2.ogg", 100, 1)

			var/transfer_moles = inside_air.volume/(inside_air.temperature * R_IDEAL_GAS_EQUATION)
			var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
			if(inside_air)
				inside_air.merge(removed)
			else
				qdel(removed)
			return
		var/inside_pressure = inside_air.return_pressure()
		var/pressure_delta = min(release_pressure - inside_pressure, (tank_air.return_pressure() - inside_pressure)/2)
		var/transfer_moles = 0

		if(pressure_delta > 0) //inside pressure lower than release pressure
			if(tank_air.temperature > 0)
				transfer_moles = pressure_delta*inside_air.volume/(inside_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				inside_air.merge(removed)

		else if(pressure_delta < 0) //inside pressure higher than release pressure
			var/datum/gas_mixture/t_air = get_turf_air()
			pressure_delta = inside_pressure - release_pressure

			if(t_air)
				pressure_delta = min(inside_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than inside pressure
				transfer_moles = pressure_delta*inside_air.volume/(inside_air.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = inside_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the inside gas, we're in space or some shit
					qdel(removed)

/obj/structure/closet/airbubble/proc/process_preserve_temp()
	if (inside_air && inside_air.volume > 0)
		var/delta = inside_air.temperature - T20C
		inside_air.temperature -= max(-10, min(10, round(delta/4,0.1)))

/obj/structure/closet/airbubble/return_air()
	if(use_internal_tank)
		return inside_air
	return ..()

/obj/structure/closet/airbubble/proc/get_turf_air()
	var/turf/T = get_turf(src)
	if(T)
		. = T.return_air()
	return

/obj/structure/closet/airbubble/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. =  inside_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return


/obj/structure/closet/airbubble/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = inside_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.temperature
	return

/obj/structure/closet/airbubble/process()
	if (!(process_ticks % 4))
		process_preserve_temp()

	if (!(process_ticks % 3))
		process_tank_give_air()

	process_ticks = (process_ticks + 1) % 17

/obj/structure/closet/airbubble/proc/add_inside()
	inside_air = new
	inside_air.temperature = T20C
	inside_air.volume = 2
	inside_air.adjust_multi("oxygen", O2STANDARD*inside_air.volume/(R_IDEAL_GAS_EQUATION*inside_air.temperature), "nitrogen", N2STANDARD*inside_air.volume/(R_IDEAL_GAS_EQUATION*inside_air.temperature))
	return inside_air

// Syndicate airbubble
/obj/item/airbubble/syndie
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments. This does not seem like a regular color scheme"
	icon_state = "airbubble_syndie_fact_folded"
	syndie = TRUE

/obj/structure/closet/airbubble/syndie
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments. This does not seem like a regular color scheme"
	icon_state = "airbubble_syndie"
	icon_closed = "airbubble_syndie"
	icon_closed = "airbubble_syndie"
	icon_opened = "airbubble_syndie_open"
	item_path = /obj/item/airbubble/syndie
	syndie = TRUE