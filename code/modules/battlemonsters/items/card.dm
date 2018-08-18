/obj/item/battle_monsters/card
	name = "battle monsters card"
	desc = "A battle monster's card."
	var/datum/battle_monsters/element/prefix_datum
	var/datum/battle_monsters/monster/root_datum
	var/datum/battle_monsters/title/suffix_datum
	w_class = ITEMSIZE_TINY

	//Card information here

/obj/item/battle_monsters/card/New(var/turf/loc,var/prefix,var/root,var/title)
	. = ..()
	Generate_Card(prefix, root, title)

/obj/item/battle_monsters/card/attackby(var/obj/item/attacking, var/mob/user)
	if(istype(attacking,/obj/item/battle_monsters/card) && attacking != src)
		var/obj/item/battle_monsters/card/adding_card = attacking
		make_deck(user,adding_card)

/obj/item/battle_monsters/card/attack_self(mob/user as mob)
	flip_card(user)

/obj/item/battle_monsters/card/proc/make_deck(var/mob/user,var/obj/item/battle_monsters/card/adding_card)

	var/obj/item/battle_monsters/deck/new_deck = new(src.loc)

	if(src.loc == user)
		//Make a hand.
		user.drop_from_inventory(src)
		new_deck.icon_state = "hand"
		user.put_in_inactive_hand(new_deck)

	if(src.loc == user)
		to_chat(user,span("notice","You combine \the [src] and the [adding_card] to form a hand."))
	else
		user.visible_message(\
			span("notice","\The [user] combines \the [src] and the [adding_card] to form a deck."),\
			span("notice","You combine \the [src] and the [adding_card] to form a deck.")\
		)

	new_deck.add_card(user,src)
	new_deck.add_card(user,adding_card)

/obj/item/battle_monsters/card/proc/flip_card(var/mob/user)
	facedown = !facedown

	if(src.loc == user)
		if(!facedown)
			to_chat(user,span("notice","You reveal \the [name] to yourself, preparing to play it face up."))
		else
			to_chat(user,span("notice", "You prepare \the [name] to be played face down."))
	else
		if(!facedown)
			user.visible_message(\
				span("notice","\The [user] flip the card face up and reveals \the [name]."),\
				span("notice","You flip the card face up and reveal \the [name].")\
			)
		else
			user.visible_message(\
				span("notice","\The [user] flips \the [name] face down."),\
				span("notice","You flip \the [name] face down.")\
			)

	update_icon()

/obj/item/battle_monsters/card/proc/Generate_Card(var/prefix,var/root,var/title)

	if(prefix)
		prefix_datum = SSbattlemonsters.FindMatchingPrefix(prefix,TRUE)
	else
		prefix_datum = SSbattlemonsters.GetRandomPrefix()

	if(root)
		root_datum = SSbattlemonsters.FindMatchingRoot(root,TRUE)
	else
		root_datum = SSbattlemonsters.GetRandomRoot()

	var/rarity_score = prefix_datum.rarity_score + root_datum.rarity_score

	if(title)
		suffix_datum = SSbattlemonsters.FindMatchingSuffix(title,TRUE)
	else if(rarity_score >= 3)
		suffix_datum = SSbattlemonsters.GetRandomSuffix()
	else
		suffix_datum = SSbattlemonsters.FindMatchingSuffix("no_title",TRUE)

	update_icon()

/obj/item/battle_monsters/card/update_icon()

	cut_overlays()

	var/rounded_rarity_score = min(max(round(prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score,1),1),4)

	if(facedown)
		icon_state = "back"
	else
		icon_state = "front_r_[rounded_rarity_score]"
		add_overlay("front_label")

		if(prefix_datum.icon_state)
			add_overlay(prefix_datum.icon_state)

		if(root_datum.icon_state)
			add_overlay(root_datum.icon_state)

		if(suffix_datum.icon_state)
			add_overlay(suffix_datum.icon_state)

		if(rounded_rarity_score >= 2)
			add_overlay("rarity_animation")

	var/matrix/M = matrix()
	switch(dir)
		if(NORTH)
			M.Turn(0)
		if(SOUTH)
			M.Turn(180)
		if(WEST)
			M.Turn(270)
		if(EAST)
			M.Turn(90)

	transform = M

/obj/item/battle_monsters/card/examine(mob/user)

	..()

	if(facedown)
		to_chat(user,span("notice","You can't examine \the [src] while it's face down!"))
		return

	SSbattlemonsters.ExamineCard(user,prefix_datum,root_datum,suffix_datum)

