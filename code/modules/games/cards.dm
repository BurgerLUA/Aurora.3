var/list/generated_cards = list()

/datum/cards/normal
	var/id = "normal"
	var/list/suits = list("spades" = "black","clubs" = "black","diamonds" = "red","hearts" = "red")
	var/list/lesser_types = list("ace","two","three","four","five","six","seven","eight","nine","ten")
	var/list/greater_types = list("jack","queen","king")
	var/list/special_types = list("joker","joker")

/datum/card/normal
	var/name = "a playing card"
	var/front_icon = "card_back"
	var/back_icon = "card_back"

/datum/cards/normal/proc/generate_cards()
	generated_cards = list()
	for(var/suit in suits)
		var/color = suits[suit]
		for(var/lesser in lesser_types)
			generate_card("[lesser] of [suit]","[color]_num","cardback")
		for(var/greater in greater_types)
			generate_card("[greater] of [suit]","[color]_col","cardback")
		for(var/special in special_types)
			generate_card(special,special,"cardback")

/datum/cards/normal/proc/generate_card(var/name,var/front_icon,var/back_icon)
	var/datum/card/normal/d = new()
	d.name = name
	d.front_icon = front_icon
	d.back_icon = back_icon
	if(!generated_cards[id])
		generated_cards[id] = list()

	generated_cards[id] += d

/obj/item/weapon/card/
	name = "a card"
	desc = "a single card"
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "cardback"
	var/deck_id = "normal"
	var/list/deck_contents = list()
	var/front_icon = "cardback"
	var/back_icon = "cardback"
	var/held_type = "single"
	var/facing = FALSE

/obj/item/weapon/card/normal
	name = "a playing card"
	desc = "a single playing card."

/obj/item/weapon/card/normal/deck
	name = "a deck of cards"
	desc = "a deck of playing cards."

/obj/item/weapon/card/normal/deck/New()
	. = ..()
	held_type = "deck"
	var/list/desiredlist = generated_cards[deck_id]
	for(var/card in desiredlist)
		deck_contents += card
	update_icon()

/obj/item/weapon/card/attack_self(var/mob/user as mob)
	toggle_visiblity()

/obj/item/weapon/card/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/weapon/card))
		add_cards(O)
		return

	..()

/obj/item/weapon/card/AltClick(var/mob/user)
	//Something should go here.

/obj/item/weapon/card/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	if(!ishuman(over) || !(over in viewers(3))) return

	if(!deck_contents.len)
		usr << "There are no cards in the deck."
		return

	deal_to(usr, over)

/obj/item/weapon/card/dropped(mob/user as mob)
	if(locate(/obj/structure/table, loc))
		update_icon(user.dir)
	else
		update_icon()

/obj/item/weapon/card/pickup(mob/user as mob)
	update_icon()

/obj/item/weapon/card/examine(mob/user)
	..(user)
	if((facing || src.loc == user) && deck_contents.len)
		user.visible_message("\The [usr] peaks at \the [name].")
		user << "It contains: "
		for(var/datum/card/normal/P in deck_contents)
			user << "\The [P.name]."

/obj/item/weapon/card/verb/shuffle_deck()
	set category = "Object"
	set name = "Shuffle"
	set desc = "Shuffles the deck."
	playsound(src.loc, 'sound/items/cardshuffle.ogg', 100, 1, -4)
	user.visible_message("\The [usr] shuffles \the [name].")
	deck_contents = shuffle(deck_contents)
	update_icon()

/obj/item/weapon/card/verb/discard()
	set category = "Object"
	set name = "Discard"
	set desc = "Place a card from your hand in front of you."

	var/obj/item/weapon/card/card_to_discard

	if(held_type == "deck")
		card_to_discard = remove_top_card()
	else
		var/list/to_discard = list()
		var/i = 1
		for(var/datum/card/normal/P in deck_contents)
			to_discard[P.name] = i
			i += 1
		var/discarding = input("Which card do you wish to put down?") as null|anything in to_discard
		card_to_discard = remove_card(to_discard[discarding])

	card_to_discard.loc = get_step(usr,usr.dir)
	var/card_name = "a playing card"
	if(card_to_discard.facing)
		var/datum/card/normal/topcard = deck_contents[1]
		card_name = "the [topcard.name]"

	user.visible_message("\The [user] discards \the [card_name].")

/obj/item/weapon/card/proc/deal_to(mob/user, mob/target, var/index = 0)
	var/obj/item/weapon/card/card_to_deal
	if(index == 0)
		card_to_deal = remove_top_card()
	else
		card_to_deal = remove_card(index)

	var/card_name = "a playing card"
	if(card_to_deal.facing)
		var/datum/card/normal/topcard = deck_contents[1]
		card_name = "the [topcard.name]"

	if(user==target)
		user.visible_message("\The [user] deals \the [card_name] to \himself.")
	else
		user.visible_message("\The [user] deals \the [card_name] to \the [target].")

	card_to_deal.throw_at(get_step(target,target.dir),10,1,card_to_deal)
	return card_to_deal

/obj/item/weapon/card/proc/convert_to(mob/user, var/convert_type)
	var/oldname = name
	held_type = convert_type
	update_icon()
	user.visible_message("\The [user] converts \the [oldname] into [name].")

/obj/item/weapon/card/proc/remove_top_card()
	var/index_to_remove = 1
	if(!facing)
		index_to_remove = deck_contents.len
	if(held_type == "deck")
		user.visible_message("\The [user] removes a card from the top of \the [name].")
	return remove_card(index_to_remove)

/obj/item/weapon/card/proc/toggle_visiblity()
	facing = !facing
	user.visible_message("\The [user] [facing ? "looks at" : "hides"] their hand.")
	update_icon()

/obj/item/weapon/card/proc/add_cards(mob/user, var/obj/item/weapon/card/card_to_add)
	var/add_count = 0
	for(var/datum/card/normal/card in card_to_add)
		add_count += 1
		if(facing)
			deck_contents.Insert(card_to_add,1)
		else
			deck_contents += card_to_add

	var/use_noun = "a card"
	if(use_noun > 1)
		use_noun = "[add_count] cards"
	user.visible_message("\The [user] adds [use_noun] to the top of the deck.")
	qdel(card_to_add)
	update_icon()

/obj/item/weapon/card/proc/remove_card(var/card_index = 0)
	var/obj/item/weapon/card/normal/the_card = new(loc)
	the_card.contents = list(deck_contents[card_index])
	the_card.facing = facing
	deck_contents.Remove(card_index)
	update_icon()
	return the_card

/obj/item/weapon/card/update_icon(var/direction = 0) //Also updates names

	if(held_type != "deck" && !deck_contents.len)
		qdel(src)
		return
	else if(contents.len > 1 && deck_contents.len < 7)
		held_type = "multi"
	else
		held_type = "single"

	cut_overlays()

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Translate( 0,  0)
			if(SOUTH)
				M.Translate( 0,  4)
			if(WEST)
				M.Turn(90)
				M.Translate( 3,  0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2,  0)

	switch(held_type)
		if("deck")
			name = "a deck of cards"
			desc = "a deck of playing cards."
			icon_state = "deck"
		if("single")
			if(contents.len == 1)
				name = "a playing card"
				desc = "a single playing card."
			else
				name = "a stack of cards"
				desc = "a sizeable stack fo playing cards."

			if(facing)
				var/datum/card/normal/topcard = deck_contents[1]
				icon_state = topcard.front_icon
			else
				var/datum/card/normal/topcard = deck_contents[deck_contents.len]
				icon_state = topcard.back_icon

		if("multi")
			name = "a hand of cards"
			desc = "a hand of playing cards."
			var/offset = Floor(20/deck_contents.len)
			var/i = 0
			for(var/datum/card/normal/P in deck_contents)
				var/image/I = new(src.icon, (!facing ? "[P.back_icon]" : "[P.front_icon]") )
				//I.pixel_x = origin+(offset*i)
				switch(direction)
					if(SOUTH)
						I.pixel_x = 8-(offset*i)
					if(WEST)
						I.pixel_y = -6+(offset*i)
					if(EAST)
						I.pixel_y = 8-(offset*i)
					else
						I.pixel_x = -7+(offset*i)
				I.transform = M
				add_overlay(I)
				i++
