// These are pricey, but damn do they look nice.
/turf/simulated/lava
	icon = 'icons/turf/smooth/lava.dmi'
	icon_state = "smooth"
	gender = PLURAL
	smooth = SMOOTH_TRUE | SMOOTH_BORDER
	light_color = LIGHT_COLOR_LAVA
	light_range = 2
	name = "lava"
	desc = "Toasty."
	canSmoothWith = list(
			/turf/simulated/lava,
			/turf/simulated/mineral
	)
	movement_cost = 4	//moving on lava should slows you down

// Custom behavior here - we want smoothed turfs to show basalt underneath, not lava.
/turf/simulated/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/basalt.dmi'
	underlay_appearance.icon_state = "basalt"
	if (prob(20))
		underlay_appearance.icon_state += "[rand(0,12)]"
	return TRUE

/turf/simulated/lava/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(locate(/obj/structure/lattice/catwalk, src))	//should be safe to walk upon
			return 1
		if(!istype(oldloc,/turf/simulated/lava))
			to_chat(L, "<span class='warning'>You are covered by fire and heat from entering \the [src]!</span>")
		if(ishuman(L))
			L.fire_stacks += 25
			L.IgniteMob()
			L.bodytemperature += 150
			return 1
		if(isrobot(L))
			L.adjustFireLoss(rand(10,30))
			return 1
		if(isanimal(L))
			var/mob/living/simple_animal/H = L
			if(H.flying) //flying mobs will ignore the lava
				return 1
			else
				H.adjustFireLoss(rand(20,40))
		else
			L.adjustFireLoss(rand(10,50))
	..()

/turf/simulated/lava/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(!istype(newloc, /turf/simulated/lava))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

// Special asteroid variant that goes with lava better.
/turf/simulated/floor/asteroid/basalt
	name = "basalt"
	icon = 'icons/turf/basalt.dmi'
	icon_state = "basalt"
	desc = "Dark volcanic rock."
	base_name = "basalt"
	base_desc = "Dark volcanic rock."
	base_icon = 'icons/turf/basalt.dmi'
	base_icon_state = "basalt"
	light_color = LIGHT_COLOR_LAVA
	smooth = SMOOTH_FALSE
	canSmoothWith = null

	footstep_sound = "concretestep"

/turf/simulated/floor/asteroid/basalt/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = icon
	underlay_appearance.icon_state = "basalt"
	if (prob(20))
		underlay_appearance.icon_state += "[rand(0,12)]"
	return TRUE

/turf/simulated/floor/asteroid/basalt/Initialize(mapload)
	if (prob(20))
		var/variant = rand(0,12)
		icon_state = "basalt[variant]"
		switch (variant)
			if (1, 2, 3)	// fair bit of lava visible, less weak light
				light_power = 0.75
				light_range = 2
			if (5, 9)	// Not much lava visible, weak light
				light_power = 0.5
				light_range = 2
	. = ..()

/turf/simulated/floor/asteroid/ash
	name = "ash"
	icon = 'icons/turf/map_placeholders.dmi'
	icon_state = "ash"
	desc = "A fine grey ash. Looks pretty tightly packed."
	smooth = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	gender = PLURAL
	base_icon = 'icons/turf/smooth/ash.dmi'
	base_icon_state = "ash"
	footstep_sound = "sandstep"

/turf/simulated/floor/asteroid/ash/rocky
	name = "rocky ash"
	icon_state = "rockyash"
	base_icon_state = "rockyash"
	base_icon = 'icons/turf/smooth/rocky_ash.dmi'
	desc = "A fine grey ash. Seems to contain medium-sized rocks."
	footstep_sound = "gravelstep"
