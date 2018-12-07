var/list/devilservantpower_types = typesof(/datum/power/devilservant) - /datum/power/devilservant
var/list/datum/power/devilservant/devilservantpowers = list()

//Devil servant powers go here.

/datum/power/devilservant
	var/sin_cost = 0 //A sin point is generated every second for every follower, plus 1.
	var/follower_requirement = 0 //Minimum followers required to use this spell.
	var/category = "" //The category of spell. Leave blank for none.
	var/obj/item/spawning_item