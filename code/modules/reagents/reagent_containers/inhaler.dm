//Inhalers
//Just like hypopsray code
/obj/item/weapon/reagent_containers/inhaler
	name = "autoinhaler"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel."
	icon = 'icons/obj/syringe.dmi'
	item_state = "autoinjector"
	icon_state = "inhaler"
	unacidable = 1
	amount_per_transfer_from_this = 5
	volume = 5
	w_class = 2
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT

/obj/item/weapon/reagent_containers/inhaler/attack(mob/living/M as mob, mob/user as mob)

	if(!reagents.total_volume)
		user.show_message("<span class='warning'>\The [src] is empty.</span>")
		return

	var/mob/living/carbon/human/H = M

	if (!istype(H))
		return

	if ( ((CLUMSY in user.mutations) || (DUMB in user.mutations)) && prob(25))
		user.show_message("<span class='danger'>Your hand slips from clumsiness!</span>")
		eyestab(M,user)
		if(M.reagents)
			var/contained = reagentlist()
			var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_TOUCH)
			admin_inject_log(user, M, src, contained, trans)
			user.visible_message("<span class='notice'>[user] accidentally sticks the [src] in [M]'s eye and presses the injection button!</span>","<span class='notice'>You accidentally stick the [src] in [M]'s eye and press the injection button!</span>")
			user.show_message("<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")
		return

	if (!usr.IsAdvancedToolUser())
		usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	if(user == M)
		if(!M.can_eat(src))
			return
	else
		if(!M.can_force_feed(user, src))
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(user == M)
		user.visible_message("<span class='notice'>[user] sticks the [src] in their mouth and presses the injection button.</span>","<span class='notice'>You stick the [src] in your mouth and press the injection button</span>")
	else
		user.visible_message("<span class='warning'>[user] attempts to administer \the [src] to [M]...</span>","<span class='notice'>You attempt to administer \the [src] to [M]...</span>")
		if (!do_after(user, 1 SECONDS, act_target = M))
			user.show_message("<span class='notice'>You and the target need to be standing still in order to inject \the [src].</span>")
			return

		user.visible_message("<span class='notice'>[user] sticks the [src] in [M]'s mouth and presses the injection button.</span>","<span class='notice'>You stick the [src] in [M]'s mouth and press the injection button</span>")

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BREATHE)
		admin_inject_log(user, M, src, contained, trans)
		user.show_message("<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")

	return

/obj/item/weapon/reagent_containers/inhaler/attack(mob/M as mob, mob/user as mob)
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		flags &= ~OPENCONTAINER
	update_icon()
	return

/obj/item/weapon/reagent_containers/inhaler/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/inhaler/examine(mob/user)
	..(user)
	if(reagents && reagents.reagent_list.len)
		user << "<span class='notice'>It is currently loaded.</span>"
	else
		user << "<span class='notice'>It is spent.</span>"

/obj/item/weapon/reagent_containers/inhaler/dexalin
	name = "autoinhaler (dexalin)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains dexalin."

	Initialize()
		. =..()
		reagents.add_reagent("dexalin", 5)
		update_icon()
		return

/obj/item/weapon/reagent_containers/inhaler/peridaxon
	name = "autoinhaler (peridaxon)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains peridaxon."

	Initialize()
		. =..()
		reagents.add_reagent("peridaxon", 5)
		update_icon()
		return

/obj/item/weapon/reagent_containers/inhaler/hyperzine
	name = "autoinhaler (hyperzine)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains hyperzine."

	Initialize()
		. =..()
		reagents.add_reagent("hyperzine", 5)
		update_icon()
		return

/obj/item/weapon/reagent_containers/inhaler/phoron
	name = "autoinhaler (phoron)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains phoron."

	Initialize()
		. =..()
		reagents.add_reagent("phoron", 5)
		update_icon()
		return

/obj/item/weapon/reagent_containers/inhaler/soporific
	name = "autoinhaler (soporific)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains chloral hydrate."

	Initialize()
		. =..()
		reagents.add_reagent("stoxin", 5)
		update_icon()
		return

/obj/item/weapon/reagent_containers/inhaler/space_drugs
	name = "autoinhaler (space drugs)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains space drugs."

	Initialize()
		. =..()
		reagents.add_reagent("space_drugs", 5)
		update_icon()
		return

/obj/item/weapon/reagent_containers/inhaler/ammonia
	name = "autoinhaler (ammonia)"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains ammonia."

	Initialize()
		. =..()
		reagents.add_reagent("ammonia", 5)
		update_icon()
		return

