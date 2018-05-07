#define PPM 9	//Protein per meat, used for calculating the quantity of protein in an animal
#define MAX_DEVOUR_HEALTH 300 //Can't devour anyone with damage greater than this.

/mob/living
	var/mob/living/devouring	// The mob we're currently eating, if any.

/mob/living/proc/attempt_devour(var/mob/living/victim, var/eat_types, var/mouth_size = null)

	if (!victim)
		return 0

	face_atom(victim)

	if (victim == src)
		src.show_message("<span class='warning'>You can't eat yourself!</span>")
		return 0

	if (devouring == victim)
		src.show_message("<span class='notice'>You stop eating [victim].</span>")
		devouring = null
		return

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			src.show_message("<span class='warning'>\The [blocked] is in the way!</span>")
			return

	if (victim.is_diona() && src.is_diona())
		src.show_message("<span class='warning'>You can't eat other diona this way!</span>")
		return 0

	if (!src.Adjacent(victim))
		src.show_message("<span class='warning'>You're too far away from \the [victim]!</span>")
		return 0

	if (!is_valid_for_devour(victim, eat_types))
		src.show_message("<span class='warning'>You can't eat that type of creature!</span>")
		return 0

	if((victim.getBruteLoss()/victim.getMaxHealth()) * 100 > MAX_DEVOUR_HEALTH)
		src.show_message("<span class='warning'>There is nothing more to eat!</span>")
		return 0

	if (!victim.mob_size || !src.mob_size)
		src.show_message("<span class='danger'>Error, no mob size defined for [victim.type]! You have encountered a bug, report it on github </span>")
		return 0

	if (!mouth_size)
		mouth_size = src.mob_size

	if (victim.mob_size <= mouth_size)
		swallow(victim, mouth_size)
	else
		devour_gradual(victim,mouth_size)

/mob/living/proc/swallow(var/mob/living/victim, var/mouth_size)
	set waitfor = FALSE
	//This function will move the victim inside the eater's contents.. There they will be digested over time

	var/swallow_time = max(3 + (victim.mob_size * victim.mob_size) - mouth_size, 3)
	src.visible_message("<span class='warning'>[src] starts swallowing \the [victim]!</span>","<span class='warning'>You start swallowing \the [victim]...</span>")
	var/turf/ourloc = src.loc
	var/turf/victimloc = victim.loc
	devouring = victim
	if (do_mob(src, victim, swallow_time SECONDS, extra_checks = CALLBACK(src, .proc/devouring_equals, victim)))
		victim.forceMove(src)
		LAZYADD(stomach_contents, victim)
	else if (victimloc != victim.loc)
		src.show_message("<span class='warning'>You're too far away from \the [victim]!</span>")
	else if (ourloc != src.loc)
		src.show_message("<span class='warning'>You must be still to eat \the [victim]!</span>")
	else if (devouring)
		src.show_message("<span class='warning'>You failed to devour \the [victim]!</span>")

	devouring = null

/mob/living/proc/devour_gradual(var/mob/living/victim, var/mouth_size)
	set waitfor = FALSE

	devouring = victim
	var/bite_delay = 2 // In seconds
	var/bite_damage = mouth_size * bite_delay
	var/turf/ourloc = src.loc
	var/turf/victimloc = victim.loc

	//var/mob/living/carbon/human/victim_human = victim
	//var/mob/living/carbon/human/self_human = src

	src.visible_message("<span class='danger'>\The [src] starts devouring \the [victim]!</span>","<span class='danger'>You start devouring \the [victim]!</span>")

	while(TRUE)
		if(do_mob(src, victim, bite_delay SECONDS, extra_checks = CALLBACK(src, .proc/devouring_equals, victim)))

			if(!victim.composition_reagent_quantity)
				victim.calculate_composition()

			face_atom(victim)

			//Add blood
			add_blood(victim)

			var/turf/simulated/location01 = get_turf(victim)
			if(istype(location01))
				location01.add_blood(victim)

			var/turf/simulated/location02 = get_turf(src)
			if(istype(location02))
				location02.add_blood(victim)

			//Health effects
			var/health_scale  = (victim.getBruteLoss()/victim.getMaxHealth()) * 100
			switch(health_scale)
				if(25 to 50)
					bite_damage *= 2
				if(50 to 100)
					bite_damage *= 3
				if(100 to 150)
					bite_damage *= 4
				if(150 to 200)
					bite_damage *= 5
				if(200 to INFINITY)
					bite_damage *= 10

			victim.apply_damage(bite_damage,BRUTE)
			ingested.add_reagent(victim.composition_reagent, bite_damage * 0.5)
			visible_message("<span class='danger'>[src] bites a chunk out of \the [victim]!</span>","<span class='danger'>[bitemessage(victim)]!</span>")

			if (health_scale > 300)
				src.visible_message("<span class='danger'>\The [src] finishes devouring \the [victim]!</span>","<span class='notice'>You finish devouring \the [victim].</span>")
				devouring = null
				break

		else
			devouring = null
			if (victim && victimloc != victim.loc)
				src.show_message("<span class='warning'>You're too far away from \the [victim]!</span>")
			else if (ourloc != src.loc)
				src.show_message("<span class='warning'>You must be still to eat \the [victim]!</span>")
			else
				src.show_message("<span class='warning'>You failed to devour \the [victim]!</span>")
			break

/mob/living/proc/devouring_equals(target)
	return target && devouring == target

//this function gradually digests things inside the mob's contents.
//It is called from life.dm. Any creatures that don't want to digest their contents simply don't call it
/mob/living/proc/handle_stomach()
	if (stomach_contents)
		for(var/thing in stomach_contents)
			var/mob/living/M = thing
			if(M.loc != src)//if something somehow escaped the stomach, then we remove it
				LAZYREMOVE(stomach_contents, M)
				continue

			if(!M.composition_reagent_quantity)
				M.calculate_composition()

			var/dmg_factor = 2*log(M.mob_size)	// log(n) is natural log in BYOND.
			if (dmg_factor <= 0)
				dmg_factor = 0.5

			M.adjustBruteLoss(round(dmg_factor * 0.33, 0.1) || 0.1)
			M.adjustFireLoss(round(dmg_factor * 0.66, 0.1) || 0.1)

			ingested.add_reagent(M.composition_reagent, M.composition_reagent_quantity * dmg_factor)

			if (M.stat == DEAD && !stomach_contents[M])	// If the mob has died, poke the consuming mob about it.
				stomach_contents[M] = TRUE	// So the message doesn't play more than once.
				continue

			var/damage_dealt = (M.getFireLoss() * 0.66) + (M.getBruteLoss() * 0.33)
			if (stomach_contents[M] && (damage_dealt >= M.maxHealth * 1.5))	//If we've consumed all of it (plus a bit), then digestion is finished.
				LAZYREMOVE(stomach_contents, M)
				qdel(M)

//Helpers
/proc/bitemessage(var/mob/living/victim)
	return pick(
		"You take a bite out of \the [victim]",
		"You rip a chunk off of \the [victim]",
		"You consume a piece of \the [victim]",
		"You feast upon your prey",
		"You chow down on \the [victim]",
		"You gobble \the [victim]'s flesh")

/proc/devour_add_blood(var/mob/living/M, var/turf/location, var/datum/reagents/vessel)
	for(var/datum/reagent/blood/source in vessel.reagent_list)
		var/obj/effect/decal/cleanable/blood/B = new /obj/effect/decal/cleanable/blood(location)

		// Update appearance.
		if(source.data["blood_colour"])
			B.basecolor = source.data["blood_colour"]
			B.update_icon()

		// Update blood information.
		if(source.data["blood_DNA"])
			B.blood_DNA = list()
			if(source.data["blood_type"])
				B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				B.blood_DNA[source.data["blood_DNA"]] = "O+"

		// Update virus information.
		if(source.data["virus2"])
			B.virus2 = virus_copylist(source.data["virus2"])

		B.fluorescent  = 0
		B.invisibility = 0

/proc/turf_hasblood(var/turf/test)
	for (var/obj/effect/decal/cleanable/blood/b in test)
		return 1
	return 0

/proc/is_valid_for_devour(var/mob/living/test, var/eat_types)
	//eat_types must contain all types that the mob has. For example we need both humanoid and synthetic to eat an IPC.
	var/test_types = test.find_type()
	. = (eat_types & test_types) == test_types

/mob/living/proc/calculate_composition()
	if (!composition_reagent)//if no reagent has been set, then we'll set one
		var/type = find_type(src)
		if (type & TYPE_SYNTHETIC)
			src.composition_reagent = "iron"
		else
			src.composition_reagent = "protein"

	//if the mob is a simple animal with a defined meat quantity
	if (istype(src, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = src
		if (SA.meat_amount)
			src.composition_reagent_quantity = SA.meat_amount*2*PPM

		//The quantity of protein is based on the meat_amount, but multiplied by 2

	var/size_reagent = (src.mob_size * src.mob_size) * 3//The quantity of protein is set to 3x mob size squared
	if (size_reagent > src.composition_reagent_quantity)//We take the larger of the two
		src.composition_reagent_quantity = size_reagent

#undef PPM
#undef MAX_DEVOUR_HEALTH
