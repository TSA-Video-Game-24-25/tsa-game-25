class_name Recipes


enum actions {
	CUT,
	MIX,
	COOK,
	STOVE,
	AUTO,
}

#	[ "FoodItemName1", "FoodItemName2", ... ]:		[ actions.Action, preload("res://ResultItem.tscn") ],
const recipes = {
	[ "Flour", "Chicken" ]:		[ actions.STOVE, preload("res://Scenes/Item/FoodItem/fried_chicken.tscn") ],
	[ "Lettuce", "CookedChicken" ]:		[ actions.MIX, preload("res://Scenes/Item/FoodItem/chicken_salad.tscn") ],
	[ "Dough", "TomatoPaste", "GratedCheese" ]:		[ actions.COOK, preload("res://Scenes/Item/FoodItem/pizza.tscn") ],
	[ "Pasta", "TomatoPaste", "GratedCheese" ]:		[ actions.STOVE, preload("res://Scenes/Item/FoodItem/spaghetti.tscn") ],
	[ "Bread", "CookedChicken", "Cheese", "Lettuce" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/chicken_sandwich.tscn") ],
	[ "Pasta", "CookedChicken", "TomatoPaste", "Lettuce", "GratedCheese" ]:		[ actions.STOVE, preload("res://Scenes/Item/FoodItem/tuscan_chicken_pasta.tscn") ],
	
	[ "Tortilla", "GratedCheese" ]:		[ actions.STOVE, preload("res://Scenes/Item/FoodItem/quesadilla.tscn") ],
	[ "Torilla", "CookedChicken", "GratedCheese" ]:		[ actions.MIX, preload("res://Scenes/Item/FoodItem/taco.tscn") ],
	[ "Chips", "Salsa" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/chips_and_salsa.tscn") ],
	[ "Tortilla", "CookedChicken", "GratedCheese", "Salsa" ]:		[ actions.MIX, preload("res://Scenes/Item/FoodItem/burrito.tscn") ],
	
	#[ "FriedRice", "SaucyGirlledChicken" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/grilled_chicken_plate.tscn") ],
	#[ "FriedRice", "SaucyGrilledSteak" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/grilled_steak_plate.tscn") ],
	#[ "FriedRice", "SaucyGrilledShrimp" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/grilled_shrimp_plate.tscn") ],
	#
	#[ "Spaghetti", "RedSauce" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/red_sauce_spaghetti.tscn") ],
	#[ "Spaghetti", "Alfredo" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/alfredo_spaghetti.tscn") ],
	#[ "Spaghetti", "Pesto" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/pesto_spaghetti.tscn") ],
	#[ "Penne", "RedSauce" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/red_sauce_penne.tscn") ],
	#[ "Penne", "Alfredo" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/alfredo_penne.tscn") ],
	#[ "Penne", "Pesto" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/pesto_penne.tscn") ],
	#[ "Rigatoni", "RedSauce" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/red_sauce_rigatoni.tscn") ],
	#[ "Rigatoni", "Alfredo" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/alfredo_rigatoni.tscn") ],
	#[ "Rigatoni", "Pesto" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/pesto_rigatoni.tscn") ],
	#[ "BowTie", "RedSauce" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/red_sauce_bow_tie.tscn") ],
	#[ "BowTie", "Alfredo" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/alfredo_bow_tie.tscn") ],
	#[ "BowTie", "Pesto" ]:		[ actions.AUTO, preload("res://Scenes/Item/FoodItem/pesto_bow_tie.tscn") ],
}

const name_to_image = {
	"FriedChicken": "Art/Meals/meal_05.png",
	"ChickenSalad": "Art/Meals/meal_07.png",
	"Pizza": "Art/Meals/meal_03.png",
	"Spaghetti": "Art/Meals/meal_02.png",
	"ChickenSandwich": "Art/Meals/meal_04.png",
	"TuscanChickenPasta": "Art/Food/Tuscan Chicken Pasta (1).png",
}
