/* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * /datum/recipe by rastaf0                  13 apr 2011 *
 * converted into a subsystem by BurgerBB    14 oct 2018 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This is powerful and flexible recipe system.
 * It exists not only for food.
 * supports both reagents and objects as prerequisites.
 * In order to use this system you have to define a deriative from /datum/recipe
 * * reagents are reagents. Acid, milc, booze, etc.
 * * items are objects. Fruits, tools, circuit boards.
 * * result is type to create as new object
 * * time is optional parameter, you shall use in in your machine,
 *   default /datum/recipe/ procs does not rely on this parameter.
 *
 *  Functions you need:
 *  SSrecipes.make(var/datum/recipe/recipe, var/obj/container as obj)
 *    Creates result inside container,
 *    deletes prerequisite reagents,
 *    transfers reagents from prerequisite objects,
 *    deletes all prerequisite objects (even not needed for recipe at the moment).
 *
 *  SSrecipes.select_recipe(list/datum/recipe/available_recipes, obj/obj as obj, exact = 1)
 *    Wonderful function that select suitable recipe for you.
 *    obj is a machine (or magik hat) with prerequisites,
 *    exact = 0 forces algorithm to ignore superfluous stuff.
 *
 *  Functions you do not need to call directly but could:
 *  SSrecipes.check_reagents(var/datum/recipe/recipe, var/datum/reagents/avail_reagents)
 *  SSrecipes.check_items(var/datum/recipe/recipe, var/obj/container as obj)
 *
 * */

/datum/recipe
	var/name = "Recipe"
	var/id
	var/list/reagents // example: = list("berryjuice" = 5) // do not list same reagent twice
	var/list/items    // example: = list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	var/list/fruit    // example: = list("fruit" = 3)
	var/coating = null//Required coating on all items in the recipe. The default value of null explitly requires no coating
	//A value of -1 is permissive and cares not for any coatings
	//Any typepath indicates a specific coating that should be present
	//Coatings are used for batter, breadcrumbs, beer-batter, colonel's secret coating, etc

	var/result        // example: = /obj/item/weapon/reagent_containers/food/snacks/donut/normal
	var/result_quantity = 1 //number of instances of result that are created.
	var/time = 100    // 1/10 part of second

	var/reagent_mix = RECIPE_REAGENT_MAX	//How to handle reagent differences between the ingredients and the results

	var/appliance = MICROWAVE//Which apppliances this recipe can be made in.
	//List of defines is in _defines/misc.dm. But for reference they are:
	/*
		MICROWAVE
		FRYER
		OVEN
		CANDYMAKER
		CEREALMAKER
	*/
	//This is a bitfield, more than one type can be used
	//Grill is presently unused and not listed