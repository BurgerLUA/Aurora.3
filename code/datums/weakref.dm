/proc/WEAKREF_TG(var/datum/input)
	if (istype(input, /datum) && !input:gcDestroyed)
		if(!input.weakref)
			input.weakref = new(input)
		return input.weakref

	return null

/datum/weakref
	var/ref

/datum/weakref/New(datum/D)
	ref = SOFTREF(D)

/datum/weakref/Destroy(force = 0)
	crash_with("Some fuck is trying to [force ? "force-" : ""]delete a weakref!")
	if (!force)
		return QDEL_HINT_LETMELIVE	// feck off

	return ..()

/datum/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if (!QDELETED(D) && D.weakref == src)
		. = D
