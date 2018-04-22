/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	item_cost = 5
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	item_cost = 6
	path = /obj/item/weapon/gun/energy/crossbow
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/forcegloves
	name = "Force Gloves"
	item_cost = 8
	path = /obj/item/clothing/gloves/force/syndicate

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	item_cost = 8
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/g9mm
	name = "Silenced 9mm"
	item_cost = 8
	path = /obj/item/weapon/storage/box/syndie_kit/g9mm
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit (APLU) Rigged Laser"
	item_cost = 8
	path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/hammer
	name = "Kneebreaker Hammer"
	item_cost = 7
	path = /obj/item/weapon/melee/hammer

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver"
	item_cost = 12
	path = /obj/item/weapon/gun/projectile/revolver
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/submachinegun
	name = "Tommy Gun"
	item_cost = 14
	path = /obj/item/weapon/gun/projectile/automatic/tommygun
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/landmine
	name = "Land Mine"
	item_cost = 5
	path = /obj/item/weapon/landmine
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/emplandmine
	name = "EMP Land Mine"
	item_cost = 4
	path = /obj/item/weapon/landmine/emp

/datum/uplink_item/item/visible_weapons/sleepylandmine
	name = "N2O Land Mine"
	item_cost = 7
	path = /obj/item/weapon/landmine/n2o

/datum/uplink_item/item/visible_weapons/powerfist
	name = "Power Fist"
	item_cost = 4
	path = /obj/item/clothing/gloves/powerfist

/datum/uplink_item/item/visible_weapons/clawedgloves
	name = "Clawed Gauntlets"
	item_cost = 5
	path = /obj/item/clothing/gloves/claws

/datum/uplink_item/item/visible_weapons/wrestling
	name = "Wrestling Manual"
	item_cost = 6
	path = /obj/item/wrestling_manual

/datum/uplink_item/item/visible_weapons/solcom
	name = "SolCom Manual"
	item_cost = 6
	path = /obj/item/sol_combat_manual
	antag_roles_discount = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Rifle"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/gun/projectile/heavysniper
	antag_roles_blacklist = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/chainsaw
	name = "Chainsaw"
	item_cost = 10
	path = /obj/item/weapon/material/twohanded/chainsaw/fueled

/datum/uplink_item/item/visible_weapons/throwing_star
	name = "Steel Throwing Star"
	item_cost = 2
	path = /obj/item/weapon/material/star
	antag_roles_discount = list(MODE_NINJA)

/datum/uplink_item/item/visible_weapons/katana
	name = "Steel Katana"
	item_cost = 8
	path = /obj/item/weapon/material/sword/katana
	antag_roles_discount = list(MODE_NINJA)

