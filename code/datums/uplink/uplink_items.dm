var/datum/uplink/uplink

/datum/uplink
	var/list/items_assoc
	var/list/datum/uplink_item/items
	var/list/datum/uplink_category/categories

/datum/uplink/New()
	items_assoc = list()
	items = init_subtypes(/datum/uplink_item)
	categories = init_subtypes(/datum/uplink_category)
	sortTim(categories, /proc/cmp_uplink_category, FALSE)

	for(var/datum/uplink_item/item in items)
		if(!item.name)
			items -= item
			continue

		items_assoc[item.type] = item

		for(var/datum/uplink_category/category in categories)
			if(item.category == category.type)
				category.items += item

	for(var/datum/uplink_category/category in categories)
		sortTim(category.items, /proc/cmp_uplink_item, FALSE)

/datum/uplink_item
	var/name
	var/desc
	var/item_cost = 0
	var/datum/uplink_category/category				// Item category
	var/list/datum/antagonist/antag_roles			// Antag roles this item is displayed to. If empty, display to all.
	var/list/datum/antagonist/antag_roles_blacklist // Antag roles this item is NOT displayed to. If empty, display to all.
	var/list/datum/antagonist/antag_job     		// Antag job this item is displayed to, if empty, display to all.
	var/list/datum/antagonist/antag_roles_discount 	//If you are in this roll, items are half priced.

/datum/uplink_item/item
	var/path = null

/datum/uplink_item/New()
	..()
	antag_roles = list()
	antag_roles_blacklist = list()
	antag_roles_discount = list()

/datum/uplink_item/proc/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/extra_args = extra_args(user)
	if(!extra_args)
		return

	if(!can_buy(U))
		return

	if(U.CanUseTopic(user, inventory_state) != STATUS_INTERACTIVE)
		return

	var/cost = cost(U.uses,U)

	var/goods = get_goods(U, get_turf(user), user, extra_args)
	if(!goods)
		return

	purchase_log(U)
	U.uses -= cost
	U.used_TC += cost
	return goods

// Any additional arguments you wish to send to the get_goods
/datum/uplink_item/proc/extra_args(var/mob/user)
	return 1

/datum/uplink_item/proc/can_buy(obj/item/device/uplink/U)
	if(cost(U.uses,U) > U.uses)
		return 0

	return can_view(U)

/datum/uplink_item/proc/is_in_role(obj/item/device/uplink/U,var/list/datum/antagonist/R)
	for(var/antag_role in R)
		var/datum/antagonist/antag = all_antag_types[antag_role]
		if(antag.is_antagonist(U.uplink_owner))
			return 1

/datum/uplink_item/proc/is_whitelisted_role(obj/item/device/uplink/U)

	if(!LAZYLEN(antag_roles))
		return 1

	if(!U || !U.uplink_owner)
		return 0

	if(is_in_role(U,antag_roles))
		return 1

	return 0

/datum/uplink_item/proc/is_blacklisted_role(obj/item/device/uplink/U)

	if(!LAZYLEN(antag_roles_blacklist))
		return 0

	if(!U || !U.uplink_owner)
		return 0

	if(is_in_role(U,antag_roles_blacklist))
		return 1

	return 0

/datum/uplink_item/proc/is_right_job(obj/item/device/uplink/U)

	if(!antag_job)
		return 1

	if(!U || !U.uplink_owner)
		return 0

	if(antag_job == U.uplink_owner.assigned_role)
		return 1

	return 0

/datum/uplink_item/proc/can_view(obj/item/device/uplink/U)

	if(is_right_job(U) && is_whitelisted_role(U) && !is_blacklisted_role(U))
		return 1

	return 0

/datum/uplink_item/proc/cost(var/telecrystals,obj/item/device/uplink/U)

	if(!LAZYLEN(antag_roles_discount))
		return item_cost

	if(is_in_role(U,antag_roles_discount))
		return Ceiling(item_cost * 0.5)

	return item_cost

/datum/uplink_item/proc/description()
	return desc

// get_goods does not necessarily return physical objects, it is simply a way to acquire the uplink item without paying
/datum/uplink_item/proc/get_goods(var/obj/item/device/uplink/U, var/loc)
	return 0

/datum/uplink_item/proc/log_icon()
	return

/datum/uplink_item/proc/purchase_log(obj/item/device/uplink/U)
	feedback_add_details("traitor_uplink_items_bought", "[src]")
	log_and_message_admins("used \the [U.loc] to buy \a [src]")
	U.purchase_log[src] = U.purchase_log[src] + 1

/********************************
*                           	*
*	Physical Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/item/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/obj/item/I = ..()
	if(!I)
		return

	if(istype(I, /list))
		var/list/L = I
		if(L.len) I = L[1]

	if(istype(I) && ishuman(user))
		var/mob/living/carbon/human/A = user
		A.put_in_any_hand_if_possible(I)
	return I

/datum/uplink_item/item/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/obj/item/I = new path(loc)
	return I

/datum/uplink_item/item/description()
	if(!desc)
		// Fallback description
		var/obj/temp = src.path
		desc = initial(temp.desc)
	return ..()

/datum/uplink_item/item/log_icon()
	var/obj/I = path
	return "\icon[I]"

/********************************
*                           	*
*	Abstract Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/abstract
	var/static/image/default_abstract_uplink_icon

/datum/uplink_item/abstract/log_icon()
	if(!default_abstract_uplink_icon)
		default_abstract_uplink_icon = image('icons/obj/pda.dmi', "pda-syn")

	return "\icon[default_abstract_uplink_icon]"

/****************
* Support procs *
****************/
/proc/get_random_uplink_items(var/obj/item/device/uplink/U, var/remaining_TC, var/loc)
	var/list/bought_items = list()
	while(remaining_TC)
		var/datum/uplink_item/I = default_uplink_selection.get_random_item(remaining_TC, U, bought_items)
		if(!I)
			break
		bought_items += I
		remaining_TC -= I.cost(remaining_TC,U)

	return bought_items
