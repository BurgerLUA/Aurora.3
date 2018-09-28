/datum/biogenerator_recipe
	var/name = "Biogenerator Recipe"
	var/category
	var/list/material_cost = list()
	var/static_cost = FALSE
	var/list/amount = list(1,2,3,4,5)
	var/id
	var/product

/datum/biogenerator_recipe/food/
	category = "Food"

/datum/biogenerator_recipe/food/biomeat
	name = "Bio Meat"
	material_cost = list("nutriment" = 6)
	product = /obj/item/weapon/reagent_containers/food/snacks/meat/biogenerated

/datum/biogenerator_recipe/food/spread
	name = "Nutri-spread"
	material_cost = list("nutriment" = 20)
	product = /obj/item/weapon/reagent_containers/food/snacks/spreads

/datum/biogenerator_recipe/medical/
	category = "Medical"

/datum/biogenerator_recipe/medical/bonegel
	name = "Bone Gel"
	material_cost = list("nutriment" = 20, "woodpulp" = 20, "oil" = 20)
	product = /obj/item/weapon/bonegel

/datum/biogenerator_recipe/hydroponics/
	category = "Hydroponics"

/datum/biogenerator_recipe/hydroponics/eznut
	name = "E-Z-Nutrient"
	material_cost = list("nutriment" = 50, "uenzyme" = 10)
	product = /obj/item/weapon/reagent_containers/glass/bottle/eznutrient

/datum/biogenerator_recipe/hydroponics/left4zed
	name = "Left-4-Zed"
	material_cost = list("nutriment" = 20, "uenzyme" = 20)
	product = /obj/item/weapon/reagent_containers/glass/bottle/left4zed

/datum/biogenerator_recipe/hydroponics/robust
	name = "Robust Harvest"
	material_cost = list("nutriment" = 50, "uenzyme" = 30)
	product = /obj/item/weapon/reagent_containers/glass/bottle/robustharvest


/datum/biogenerator_recipe/supply/
	category = "Supply"

/datum/biogenerator_recipe/supply/paper
	name = "Paper"
	material_cost = list("woodpulp" = 20)
	product = /obj/item/weapon/paper_bundle



