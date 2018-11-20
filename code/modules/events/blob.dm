/datum/event/blob
	announceWhen	= 12
	var/obj/effect/blob/core/spawned_blob
	var/area/chosen_area
	ic_name = "a biohazard"

/datum/event/blob/announce()
	level_seven_announcement()

/datum/event/infestation/proc/choose_area()
	chosen_area = random_station_area(TRUE, list(3,4), area_whitelist = list(/area/maintenance))

/datum/event/blob/setup()
	choose_area()

/datum/event/blob/start()
	var/turf/T = chosen_area.random_space()
	if(!T)
		log_and_message_admins("Blob failed to find a viable turf.")
		kill()
		return
	log_and_message_admins("Blob spawned at \the [get_area(T)]", location = T)
	spawned_blob = new /obj/effect/blob/core(T)
	for(var/i = 1; i < rand(3, 4), i++)
		spawned_blob.process()

/datum/event/blob/tick()
	if(!spawned_blob || !spawned_blob.loc)
		spawned_blob = null
		kill()
		return
	if(activeFor % 3 == 1)
		spawned_blob.process()
