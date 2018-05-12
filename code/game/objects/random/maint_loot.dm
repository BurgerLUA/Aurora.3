/obj/maint_loot
	name = "random maint setup"
	desc = "This item type is used to spawn random maint objects at round-start."
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	var/itemchance = 75
	var/specialchance = 5
	var/list/specials = list()
	var/list/holders = list()
	var/list/items = list()

/obj/maint_loot/Initialize()
	. = ..()
	place_objects()
	return INITIALIZE_HINT_QDEL

/obj/maint_loot/proc/place_objects()
	if(specials && specials.len && prob(specialchance))
		var/special_type = pickweight(specials)
		new special_type(src.loc)
	else if(holders && holders.len)
		var/holder_type = pickweight(holders)
		var/obj/holder_spawn = new holder_type(src.loc)
		if(holder_spawn && items && items.len && prob(itemchance))
			var/item_type = pickweight(items)
			new item_type(holder_spawn.loc)

/obj/maint_loot/wall
	name = "wall loot"
	holders = list(
		/obj/structure/closet = 1,
		/obj/structure/closet/crate = 2,
		/obj/structure/table/rack = 4
	)
	items = list(
		/obj/random/loot = 1
	)
	specials = list(
		/obj/random/vendor = 1,
		/obj/random/cookingoil = 0.1,
		/obj/structure/closet/firecloset/full = 0.1,
		/obj/machinery/computer/arcade/ = 0.1,
		/obj/structure/reagent_dispensers/fueltank = 1,
		/obj/structure/reagent_dispensers/watertank = 1,
		/obj/machinery/portable_atmospherics/powered/pump/filled = 0.1,
		/obj/machinery/floodlight = 0.1,
		/obj/machinery/space_heater = 0.1,
		/obj/machinery/power/port_gen/pacman = 0.1
	)