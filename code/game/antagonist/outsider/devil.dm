var/datum/antagonist/devil/devil
var/datum/antagonist/devil_servant/devil_servant

/proc/is_devil(var/mob/player)
	if(!devil || !player.mind)
		return 0
	if(player.mind in devil.current_antagonists)
		return 1

/datum/antagonist/devil
	id = MODE_DEVIL
	role_text = "Devil"
	role_text_plural = "devils"
	bantype = "devil"
	landmark_id = "devilstart"
	welcome_text = "<span class='info'>You are the devil! Visit the nearby station and encourage the crew to commit sin.</span>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_RANDSPAWN | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "huddevil"

	victory_text = "The devil wins! The station is now full of sin!"
	loss_text = "The staff managed to stop the devil!"

	victory_feedback_tag = "win - devil win"
	loss_feedback_tag = "loss - devil lost"

	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 1
	hard_cap_round = 3

	faction = "devil"

	var/list/converted_crew = list()

/datum/antagonist/devil/New()
	..()
	devil = src

/datum/antagonist/devil_servant
	id = MODE_SERVANT
	role_text = "Devil's Servant"
	role_text_plural = "Devil's Servants"
	bantype = "devil_servant"
	landmark_id = "devilservantstart"
	welcome_text = "<span class='info'>You are one of the devil's servants! Visit the nearby station and encourage the crew to commit sin. Remember, the devil is your lord. Obey every one of their commands... for now.</span>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_RANDSPAWN | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudservant"

	victory_text = "The devil wins! The station is now full of sin!"
	loss_text = "The staff managed to stop the devil!"

	victory_feedback_tag = "win - devil win"
	loss_feedback_tag = "loss - devil lost"

	initial_spawn_req = 2
	initial_spawn_target = 2
	hard_cap = 2
	hard_cap_round = 5

	faction = "devil"

	var/list/converted_crew = list()

/datum/antagonist/devil_servant/New()
	..()
	devil_servant = src