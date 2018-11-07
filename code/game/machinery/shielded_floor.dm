/obj/machinery/shielded_floor
	name = "shielded floor"
	desc = "A protective floor panel consisting of outdated Skrellian military technology designed to absorb high energy impacts from ballistic weaponry. Commonly seen repurposed for use in toxins research."
	icon = 'icons/obj/shielded_floor.dmi'
	icon_state = "on"
	layer = 2.45
	anchored = 1
	use_power = 1
	var/active = 1 //Connected to a grid.
	idle_power_usage = 0
	var/power_draw = 100

/obj/machinery/shielded_floor/update_icon()
	if(use_power && active)
		icon_state = "on"
	else
		icon_state = "off"

/obj/machinery/shielded_floor/machinery_process()
	if (!anchored)
		active = 0
		update_icon()
		return

	var/turf/T = src.loc
	if (!istype(T))
		active = 0
		update_icon()
		return

	var/obj/structure/cable/C = T.get_cable_node()

	var/datum/powernet/PN
	if (C)
		PN = C.powernet
	else
		active = 0
		update_icon()
		return

	if (!(PN && PN.draw_power(power_draw)))
		active = 0
		update_icon()
		return

	active = 1
	update_icon()