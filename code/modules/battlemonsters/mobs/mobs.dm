/mob/living/simple_animal/hostile/commanded/battlemonster
	name = "battlemonsters monster"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"

	health = 1000
	maxHealth = 1000
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	environment_smash = 0
	retribution = TRUE

	melee_damage_lower = 25
	melee_damage_upper = 25

	var/death_message = "is defeated!"

	tameable = FALSE

/mob/living/simple_animal/hostile/commanded/battlemonster/AttackingTarget() //Snowflake code
	if(!Adjacent(target_mob))
		return
	setClickCooldown(attack_delay)
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		src.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [L.name] ([L.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [src.name] ([src.ckey])</font>")
		L.visible_message("<span class='danger'>\The [src] has attacked [L]!</span>")
		src.do_attack_animation(L)
		playsound(src, 'sound/magic/demon_attack1.ogg', 100, 1)
		L.adjustHalLoss(melee_damage_lower)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/hostile/commanded/battlemonster/death()
	..(null,death_message)
	playsound(src, 'sound/magic/demon_dies.ogg', 100, 1)
	qdel(src)

/mob/living/simple_animal/hostile/commanded/battlemonster/GetTargetHealth(var/mob/living/L)
	return L.health - L.halloss

/mob/living/simple_animal/hostile/commanded/battlemonster/CanAquireTarget(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		return (L.health - L.halloss) > 0

	return TRUE






