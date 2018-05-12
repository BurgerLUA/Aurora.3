/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/list/spawnlist
	var/list/problist
	var/has_postspawn

// creates a new object and deletes itself

/obj/random/Initialize()
	. = ..()
	if (!prob(spawn_nothing_percentage))
		var/item = spawn_item()
		if (has_postspawn && item)
			post_spawn(item)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

/obj/random/proc/post_spawn(obj/thing)
	log_debug("random_obj: [DEBUG_REF(src)] registered itself as having post_spawn, but did not override post_spawn()!")

// creates the random item
/obj/random/proc/spawn_item()
	if (spawnlist)
		var/itemtype = pick(spawnlist)
		. = new itemtype(loc)

	else if (problist)
		var/itemtype = pickweight(problist)
		. = new itemtype(loc)

	else
		var/itemtype = item_to_spawn()
		. = new itemtype(loc)

	if (!.)
		log_debug("random_obj: [DEBUG_REF(src)] returned null item!")


//Technology/Buildables
/obj/random/tech
	name = "random technology"
	desc = "This is a random technology item."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	problist = list(
		/obj/random/tech/toolbox = 0.1,
		/obj/random/tech/tool = 1,
		/obj/random/tech/powercell = 1,
	)

/obj/random/tech/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	problist = list(
		/obj/item/weapon/storage/toolbox/mechanical = 3,
		/obj/item/weapon/storage/toolbox/electrical = 2,
		/obj/item/weapon/storage/toolbox/emergency = 1
	)

/obj/random/tech/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	problist = list(
		/obj/item/weapon/screwdriver = 4,
		/obj/item/weapon/wirecutters = 2,
		/obj/item/weapon/weldingtool = 2,
		/obj/item/weapon/crowbar = 4,
		/obj/item/weapon/wrench = 4,
		/obj/item/device/flashlight = 1,
		/obj/item/device/analyzer = 0.1,
		/obj/item/device/debugger = 0.1,
		/obj/item/device/multitool/hacktool = 2,
	)

/obj/random/tech/materials
	name = "random materials"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	problist = list(
		/obj/random/tech/materials/basic = 6,
		/obj/random/tech/materials/advanced	= 1,
		/obj/random/tech/materials/junk = 2
	)

/obj/random/tech/materials/basic
	name = "random basic materials"
	desc = "Basic building materials."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal_3"
	problist = list(
		/obj/item/stack/material/steel{amount = 25} = 20,
		/obj/item/stack/material/steel{amount = 10} = 8,
		/obj/item/stack/material/steel{amount = 50} = 4,

		/obj/item/stack/material/glass{amount = 25} = 10,
		/obj/item/stack/material/glass{amount = 10} = 4,
		/obj/item/stack/material/glass{amount = 50} = 2,

		/obj/item/stack/material/wood{amount = 25} = 5,
		/obj/item/stack/material/wood{amount = 10} = 2,
		/obj/item/stack/material/wood{amount = 50} = 1,

		/obj/item/stack/material/glass/reinforced{amount = 25} = 5,
		/obj/item/stack/material/glass/reinforced{amount = 10} = 2,
		/obj/item/stack/material/glass/reinforced{amount = 50} =1,

		/obj/item/stack/material/plastic{amount = 25} = 5,
		/obj/item/stack/material/plastic{amount = 10} = 2,
		/obj/item/stack/material/plastic{amount = 50} = 1,

		/obj/item/stack/material/plasteel{amount = 10} = 4
	)

/obj/random/tech/materials/advanced
	name = "random advanced materials"
	desc = "Basic building materials."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-phoron_3"
	problist = list(
		/obj/item/stack/material/gold{amount = 25} = 10,
		/obj/item/stack/material/gold{amount = 10} = 4,
		/obj/item/stack/material/gold{amount = 50} = 2,

		/obj/item/stack/material/silver{amount = 25} = 10,
		/obj/item/stack/material/silver{amount = 10} = 4,
		/obj/item/stack/material/silver{amount = 50} = 2,

		/obj/item/stack/material/phoron{amount = 25} = 5,
		/obj/item/stack/material/phoron{amount = 10} = 2,
		/obj/item/stack/material/phoron{amount = 50} = 1,

		/obj/item/stack/material/uranium{amount = 25} = 5,
		/obj/item/stack/material/uranium{amount = 10} = 2,
		/obj/item/stack/material/uranium{amount = 50} = 1,
	)

/obj/random/tech/materials/junk
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/items.dmi'
	icon_state = "gauze_3"
	problist = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/weapon/tape_roll = 1,
		/obj/item/weapon/packageWrap = 1,
	)

/obj/random/tech/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	problist = list(
		/obj/item/weapon/cell/apc = 4,
		/obj/item/weapon/cell/crap = 1,
		/obj/item/weapon/cell/device = 0.1,
		/obj/item/weapon/cell/high = 2,
		/obj/item/weapon/cell/hyper = 1,
		/obj/item/weapon/cell/super = 1
	)

/obj/random/weapon
	name = "random weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	problist = list(
		/obj/random/weapon/melee = 4,
		/obj/random/melee/ranged = 1
	)

/obj/random/weapon/melee
	name = "random melee weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	problist = list(
		/obj/random/weapon/melee/advanced = 0.1,
		/obj/random/weapon/melee/modern = 1,
		/obj/random/weapon/melee/primitive = 0.1
	)

/obj/random/weapon/melee/advanced
	name = "random advanced melee weapon"
	desc = "Weapons meant to kill."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "swordblue"
	problist = list(
		/obj/item/weapon/melee/energy/sword = 4,
		/obj/item/weapon/melee/energy/glaive = 1,
		/obj/item/weapon/melee/energy/sword/pirate  = 1,
		/obj/item/weapon/melee/chainsword = 1,
		/obj/item/weapon/melee/hammer/powered = 1
	)

/obj/random/weapon/melee/modern
	name = "random modern melee weapon"
	desc = "Weapons that make sense for a soldier to carry around."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	problist = list(
		/obj/item/weapon/material/hatchet/tacknife = 4,
		/obj/item/weapon/melee/classic_baton = 2,
		/obj/item/weapon/melee/telebaton = 2,
		/obj/item/weapon/material/butterfly = 1,
		/obj/item/weapon/material/butterfly/switchblade = 1,
		/obj/item/weapon/material/twohanded/baseballbat = 0.5,
		/obj/item/weapon/material/twohanded/baseballbat/metal = 0.5,
		/obj/item/weapon/material/sword/trench = 1,
	)

/obj/random/weapon/melee/primitive
	name = "random primitive melee weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	problist = list(
		/obj/item/weapon/material/sword = 4,
		/obj/item/weapon/material/sword/katana = 2,
		/obj/item/weapon/material/sword/rapier = 1,
		/obj/item/weapon/material/sword/longsword = 2,
		/obj/item/weapon/material/sword/trench = 4,
		/obj/item/weapon/material/sword/sabre = 1,
		/obj/item/weapon/material/sword/axe = 2,
		/obj/item/weapon/material/sword/khopesh = 1,
		/obj/item/weapon/material/sword/dao = 1,
		/obj/item/weapon/material/sword/gladius = 1,
		/obj/item/weapon/material/twohanded/zweihander = 0.1,
		/obj/item/weapon/material/twohanded/spear/steel = 0.1,
		/obj/item/weapon/material/twohanded/pike = 0.1,
		/obj/item/weapon/material/twohanded/pike/halberd = 0.1,
		/obj/item/weapon/material/twohanded/pike/pitchfork = 0.2,
		/obj/item/weapon/material/scythe = 1
	)

/obj/random/melee/ranged
	name = "random ranged weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "crossbow"
	problist = list(
		/obj/random/melee/ranged/projectile = 4,
		/obj/random/melee/ranged/energy = 1
	)

/obj/random/melee/ranged/projectile
	name = "random ranged projectile weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	problist = list(
		/obj/item/weapon/gun/launcher/crossbow = 1,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi = 1,
		/obj/item/weapon/gun/projectile/automatic/wt550 = 2,
		/obj/item/weapon/gun/projectile/automatic/c20r = 1,
		/obj/item/weapon/gun/projectile/contender = 1,
		/obj/item/weapon/gun/projectile/deagle = 0.1,
		/obj/item/weapon/gun/projectile/dragunov = 0.1,
		/obj/item/weapon/gun/projectile/pirate = 4,
		/obj/item/weapon/gun/projectile/pistol = 2,
		/obj/item/weapon/gun/projectile/revolver = 2,
		/obj/item/weapon/gun/projectile/revolver/derringer = 2,
		/obj/item/weapon/gun/projectile/revolver/lemat = 0.1,
		/obj/item/weapon/gun/projectile/revolver/mateba = 0.1,
		/obj/item/weapon/gun/projectile/sec/lethal = 1,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel = 2,
		/obj/item/weapon/gun/projectile/shotgun/pump = 1,
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 2,
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage = 0.1,
		/obj/item/weapon/gun/projectile/tanto = 2
	)

/obj/random/melee/ranged/projectile/security
	name = "random ranged projectile weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"
	problist = list(
		/obj/item/weapon/gun/projectile/sec = 3,
		/obj/item/weapon/gun/projectile/sec/wood = 1
	)

/obj/random/melee/ranged/energy
	name = "random ranged energy weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "retro"
	problist = list(
		/obj/item/weapon/gun/energy/gun = 8,
		/obj/item/weapon/gun/energy/crossbow = 2,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow = 1,
		/obj/item/weapon/gun/energy/decloner = 1,
		/obj/item/weapon/gun/energy/gun/nuclear = 1,
		/obj/item/weapon/gun/energy/ionrifle = 1,
		/obj/item/weapon/gun/energy/kinetic_accelerator = 2,
		/obj/item/weapon/gun/energy/laser = 2,
		/obj/item/weapon/gun/energy/net = 1,
		/obj/item/weapon/gun/energy/pistol = 2,
		/obj/item/weapon/gun/energy/plasmacutter = 1,
		/obj/item/weapon/gun/energy/retro = 1
	)

//First Aid
/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	problist = list(
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1,
		/obj/item/bodybag = 2,
		/obj/item/bodybag/cryobag = 1,
		/obj/item/weapon/storage/pill_bottle/kelotane = 2,
		/obj/item/weapon/storage/pill_bottle/antitox = 2,
		/obj/item/weapon/storage/pill_bottle/tramadol = 2,
		/obj/item/weapon/reagent_containers/syringe/antitoxin = 2,
		/obj/item/weapon/reagent_containers/syringe/antiviral = 1,
		/obj/item/weapon/reagent_containers/syringe/inaprovaline = 2,
		/obj/item/stack/nanopaste = 1
	)

/obj/random/medical/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	problist = list(
		/obj/item/weapon/storage/firstaid/regular = 3,
		/obj/item/weapon/storage/firstaid/toxin = 2,
		/obj/item/weapon/storage/firstaid/o2 = 2,
		/obj/item/weapon/storage/firstaid/adv = 1,
		/obj/item/weapon/storage/firstaid/fire = 2
	)











//Loot

/obj/random/loot
	name = "random maintenance loot items"
	desc = "Stuff for the maint-dwellers."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	problist = list(
		/obj/random/loot/arcade = 1,

	)

/obj/random/loot/arcade
	name = "random arcade loot"
	desc = "Arcade loot!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"
	spawnlist = list(
		/obj/item/weapon/storage/box/snappops			= 11,
		/obj/item/clothing/under/syndicate/tacticool	= 5,
		/obj/item/toy/sword								= 22,
		/obj/item/weapon/gun/projectile/revolver/capgun	= 11,
		/obj/item/toy/crossbow							= 11,
		/obj/item/weapon/storage/fancy/crayons			= 11,
		/obj/item/toy/spinningtoy						= 11,
		/obj/item/toy/prize/ripley						= 1,
		/obj/item/toy/prize/fireripley					= 1,
		/obj/item/toy/prize/deathripley					= 1,
		/obj/item/toy/prize/gygax						= 1,
		/obj/item/toy/prize/durand						= 1,
		/obj/item/toy/prize/honk						= 1,
		/obj/item/toy/prize/marauder					= 1,
		/obj/item/toy/prize/seraph						= 1,
		/obj/item/toy/prize/mauler						= 1,
		/obj/item/toy/prize/odysseus					= 1,
		/obj/item/toy/prize/phazon						= 1,
		/obj/item/toy/waterflower						= 5,
		/obj/random/action_figure						= 11,
		/obj/random/plushie								= 44,
		/obj/item/toy/cultsword							= 5,
		/obj/item/toy/syndicateballoon					= 5,
		/obj/item/toy/nanotrasenballoon					= 5,
		/obj/item/toy/katana							= 11,
		/obj/item/toy/bosunwhistle						= 5,
		/obj/item/weapon/storage/belt/champion			= 11,
		/obj/item/weapon/pen/invisible					= 5,
		/obj/item/weapon/grenade/fake					= 1,
		/obj/item/weapon/bikehorn						= 11,
		/obj/item/clothing/mask/fakemoustache			= 11,
		/obj/item/clothing/mask/gas/clown_hat			= 11,
		/obj/item/clothing/mask/gas/mime				= 11,
		/obj/item/weapon/gun/energy/wand/toy			= 5,
		/obj/item/device/binoculars						= 11,
		/obj/item/device/megaphone						= 11
	)