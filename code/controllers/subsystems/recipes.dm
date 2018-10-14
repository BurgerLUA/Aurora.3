#define RECIPE_REAGENT_REPLACE 0 //Reagents in the ingredients are discarded.
#define RECIPE_REAGENT_MAX 1 //The result will contain the maximum of each reagent present between the two pools. Compiletime result, and sum of ingredients
#define RECIPE_REAGENT_MIN 2 //As above, but the minimum, ignoring zero values.
#define RECIPE_REAGENT_SUM 3 //The entire quantity of the ingredients are added to the result


var/datum/controller/subsystem/recipes/SSrecipes

/datum/controller/subsystem/recipes
	name = "Recipes"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE
	var/list/recipes_microwave = list()
	var/list/recipes_oven = list()
	var/list/recipes_fryer = list()

/datum/controller/subsystem/recipes/New()
	NEW_SS_GLOBAL(SSrecipes)

/datum/controller/subsystem/recipes/Recover()
	src.recipes_microwave = SSrecipes.recipes_microwave
	src.recipes_oven = SSrecipes.recipes_oven
	src.recipes_fryer = SSrecipes.recipes_fryer

/datum/controller/subsystem/recipes/Initialize(timeofday)
	recipes_microwave = GenerateRecipes(MICROWAVE)
	recipes_oven = GenerateRecipes(OVEN)
	recipes_fryer = GenerateRecipes(FRYER)

/datum/controller/subsystem/recipes/proc/GenerateRecipes(var/appliancetype)
	if(!appliancetype)
		return 0

	var/list/returning = list()

	for (var/datum/recipe/R in RECIPE_LIST(appliancetype))
		var/datum/recipe/created = new R
		if(created && created.id)
			returning[created.id] = created

	return returning

//When exact is false, extraneous ingredients are ignored
//When exact is true, extraneous ingredients will fail the recipe
//In both cases, the full complement of required inredients is still needed
/datum/controller/subsystem/recipes/proc/select_recipe(var/list/datum/recipe/available_recipes, var/obj/obj as obj, var/exact = 0)
	var/list/datum/recipe/possible_recipes = list()
	for (var/datum/recipe/recipe in available_recipes)
		if((check_reagents(obj.reagents) < exact) || (check_items(obj) < exact) || (check_fruit(obj) < exact))
			continue
		possible_recipes |= recipe
	if (!possible_recipes.len)
		return null
	else if (possible_recipes.len == 1)
		return possible_recipes[1]
	else //okay, let's select the most complicated recipe
		sortTim(possible_recipes, /proc/cmp_recipe_complexity_dsc)
		return possible_recipes[1]

// food-related
//This proc is called under the assumption that the container has already been checked and found to contain the necessary ingredients
/datum/controller/subsystem/recipes/proc/make_food(var/list/datum/recipe/recipe, var/obj/container as obj)
	if(!recipe.result)
		return

	//We will subtract all the ingredients from the container, and transfer their reagents into a holder
	//We will not touch things which are not required for this recipe. They will be left behind for the caller
	//to decide what to do. They may be used again to make another recipe or discarded, or merged into the results,
	//thats no longer the concern of this proc
	var/datum/reagents/buffer = new /datum/reagents(999999999999, null)//

	//Find items we need
	if (recipe.items && recipe.items.len)
		for (var/i in recipe.items)
			var/obj/item/I = locate(i) in container
			if (I && I.reagents)
				I.reagents.trans_to_holder(buffer,I.reagents.total_volume)
				qdel(I)

	//Find fruits
	if (recipe.fruit && recipe.fruit.len)
		var/list/checklist = list()
		checklist = recipe.fruit.Copy()

		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			if (checklist[G.seed.kitchen_tag] > 0)
				//We found a thing we need
				checklist[G.seed.kitchen_tag]--
				if (G && G.reagents)
					G.reagents.trans_to_holder(buffer,G.reagents.total_volume)
				qdel(G)

	//And lastly deduct necessary quantities of reagents
	if (recipe.reagents && recipe.reagents.len)
		for (var/r in recipe.reagents)
			//Doesnt matter whether or not there's enough, we assume that check is done before
			container.reagents.trans_id_to(buffer, r, recipe.reagents[r])

	/*
	Now we've removed all the ingredients that were used and we have the buffer containing the total of
	all their reagents.

	Next up we create the result, and then handle the merging of reagents depending on the mix setting
	*/
	var/tally = 0

	/*
	If we have multiple results, holder will be used as a buffer to hold reagents for the result objects.
	If, as in the most common case, there is only a single result, then it will just be a reference to
	the single-result's reagents
	*/
	var/datum/reagents/holder = new/datum/reagents(9999999999)
	var/list/results = list()
	while (tally < recipe.result_quantity)
		var/obj/result_obj = new recipe.result(container)
		results.Add(result_obj)

		if (!result_obj.reagents)//This shouldn't happen
			//If the result somehow has no reagents defined, then create a new holder
			result_obj.reagents = new /datum/reagents(buffer.total_volume*1.5, result_obj)

		if (recipe.result_quantity == 1)
			qdel(holder)
			holder = result_obj.reagents
		else
			result_obj.reagents.trans_to(holder, result_obj.reagents.total_volume)
		tally++


	switch(recipe.reagent_mix)
		if (RECIPE_REAGENT_REPLACE)
			//We do no transferring
		if (RECIPE_REAGENT_SUM)
			//Sum is easy, just shove the entire buffer into the result
			buffer.trans_to_holder(holder, buffer.total_volume)
		if (RECIPE_REAGENT_MAX)
			//We want the highest of each.
			//Iterate through everything in buffer. If the target has less than the buffer, then top it up
			for (var/datum/reagent/R in buffer.reagent_list)
				var/rvol = holder.get_reagent_amount(R.id)
				if (rvol < R.volume)
					//Transfer the difference
					buffer.trans_id_to(holder, R.id, R.volume-rvol)

		if (RECIPE_REAGENT_MIN)
			//Min is slightly more complex. We want the result to have the lowest from each side
			//But zero will not count. Where a side has zero its ignored and the side with a nonzero value is used
			for (var/datum/reagent/R in buffer.reagent_list)
				var/rvol = holder.get_reagent_amount(R.id)
				if (rvol == 0) //If the target has zero of this reagent
					buffer.trans_id_to(holder, R.id, R.volume)
					//Then transfer all of ours

				else if (rvol > R.volume)
					//if the target has more than ours
					//Remove the difference
					holder.remove_reagent(R.id, rvol-R.volume)


	if (results.len > 1)
		//If we're here, then holder is a buffer containing the total reagents for all the results.
		//So now we redistribute it among them
		var/total = holder.total_volume
		for (var/i in results)
			var/atom/a = i //optimisation
			holder.trans_to(a, total / results.len)

	return results


//general version
/datum/controller/subsystem/recipes/proc/make(var/list/datum/recipe/recipe, var/obj/container as obj)
	var/obj/result_obj = new recipe.result(container)
	for (var/obj/O in (container.contents-result_obj))
		O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
		qdel(O)
	container.reagents.clear_reagents()
	return result_obj

//This is called on individual items within the container.
/datum/controller/subsystem/recipes/proc/check_coating(var/list/datum/recipe/recipe, var/obj/O)
	if(!istype(O,/obj/item/weapon/reagent_containers/food/snacks))
		return 1//Only snacks can be battered

	if (recipe.coating == -1)
		return 1 //-1 value doesnt care

	var/obj/item/weapon/reagent_containers/food/snacks/S = O
	if (!S.coating)
		if (!recipe.coating)
			return 1
		return 0
	else if (S.coating.type == recipe.coating)
		return 1

	return 0

/datum/controller/subsystem/recipes/proc/check_items(var/list/datum/recipe/recipe, var/obj/container as obj)

	if (!recipe.items || !recipe.items.len)
		return 1

	. = 1

	if (recipe.items && recipe.items.len)
		var/list/checklist = list()
		checklist = recipe.items.Copy() // You should really trust Copy
		for(var/obj/O in container)
			if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown))
				continue // Fruit is handled in check_fruit().
			var/found = 0
			for(var/i = 1; i < checklist.len+1; i++)
				var/item_type = checklist[i]
				if (istype(O,item_type))
					if(check_coating(O))
						checklist.Cut(i, i+1)
						found = 1
						break

			if (!found)
				. = 0
			if (!checklist.len && . != 1)
				return //No need to iterate through everything if we know theres at least oen extraneous ingredient
		if (checklist.len)
			. = -1

	return .

/datum/controller/subsystem/recipes/proc/check_fruit(var/list/datum/recipe/recipe, var/obj/container)
	if (!recipe.fruit || !recipe.fruit.len)
		return 1

	. = 1

	if(recipe.fruit && recipe.fruit.len)
		var/list/checklist = list()
		 // You should trust Copy().
		checklist = recipe.fruit.Copy()
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			if (check_coating(G))
				checklist[G.seed.kitchen_tag]--

		for(var/ktag in checklist)
			if(!isnull(checklist[ktag]))
				if(checklist[ktag] < 0)
					. = 0
				else if(checklist[ktag] > 0)
					. = -1
					break
	return .

/datum/controller/subsystem/recipes/proc/check_reagents(var/list/datum/recipe/recipe, var/datum/reagents/avail_reagents)
	if (!recipe.reagents || !recipe.reagents.len)
		return 1

	if (!avail_reagents)
		return 0

	. = 1

	for (var/r_r in recipe.reagents)
		var/aval_r_amnt = avail_reagents.get_reagent_amount(r_r)
		if (aval_r_amnt - recipe.reagents[r_r] >= 0)
			if (aval_r_amnt > recipe.reagents[r_r])
				. = 0
		else
			return -1

	if ((recipe.reagents ? (recipe.reagents.len) : (0)) < avail_reagents.reagent_list.len)
		return 0

	return .