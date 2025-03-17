class_name Recipes


enum actions {
	CUT,
	MIX,
	COOK,
}

#	[ FoodItemName1, FoodItemName2, ... ]: [ Action, ResultItem ]
const recipes = {
	[ "Lettuce", "Tomato", "CookedChicken" ]: [ actions.MIX, preload("res://Scenes/Item/FoodItem/chicken_salad.tscn") ],
}
