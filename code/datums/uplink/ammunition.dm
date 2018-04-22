/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/mc9mm
	name = "9mm"
	item_cost = 1
	path = /obj/item/ammo_magazine/mc9mm
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	item_cost = 1
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/tommygunmag
	name = "Tommygun Magazine (.45)"
	item_cost = 2
	path = /obj/item/ammo_magazine/tommymag
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/ammo/a357
	name = ".357"
	item_cost = 2
	path = /obj/item/ammo_magazine/a357
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/ammo/tommygundrum
	name = "Tommygun Drum Magazine (.45)"
	item_cost = 4
	path = /obj/item/ammo_magazine/tommydrum
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/ammo/sniperammo
	name = "14.5mm"
	item_cost = 4
	path = /obj/item/weapon/storage/box/sniperammo
	antag_roles_blacklist = list(MODE_NINJA)
