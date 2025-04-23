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
}

const name_to_image = {
	"FriedChicken": "Art/Meals/meal_05.png",
	"ChickenSalad": "Art/Meals/meal_07.png",
	"Pizza": "Art/Meals/meal_03.png",
	"Spaghetti": "Art/Meals/meal_02.png",
	"ChickenSandwich": "Art/Meals/meal_04.png",
	"TuscanChickenPasta": "Art/Food/Tuscan Chicken Pasta (1).png",
}
