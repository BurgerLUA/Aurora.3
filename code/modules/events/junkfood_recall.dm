/datum/event/junkfood_recall
	ic_name = "a junkfood recall"
	startWhen = 0
	var/list/affected_food = list(
		"Noggie Nougat Bar" = /obj/item/weapon/reagent_containers/food/snacks/candy,
		/obj/item/weapon/reagent_containers/food/drinks/dry_ramen,
		/obj/item/weapon/reagent_containers/food/snacks/chips,
		/obj/item/weapon/reagent_containers/food/snacks/sosjerky,
		/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
		/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,
		/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,
		/obj/item/weapon/reagent_containers/food/snacks/tastybread,
		/obj/item/weapon/reagent_containers/food/snacks/skrellsnack,
		/obj/item/weapon/reagent_containers/food/snacks/meatsnack,
		/obj/item/weapon/reagent_containers/food/snacks/maps,
		/obj/item/weapon/reagent_containers/food/snacks/nathisnack
	)
	var/obj/item/weapon/reagent_containers/food/selected_bar
	var/selected_bar_name

/datum/event/junkfood_recall/announce()
	var/author = "[current_map.company_name] Editor"
	var/channel = "Tau Ceti Daily"
	var/body = "Getmore Chocolate Corp. has put out a recall notice today for a line of their famous "
	var/datum/feed_channel/ch =  SSnews.GetFeedChannel(channel)
	SSnews.SubmitArticle(body, author, ch, null, 1)