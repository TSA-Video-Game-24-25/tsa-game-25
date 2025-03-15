class_name Recipes


enum actions {
	CUT,
	MIX,
	COOK,
}

#	[ FoodItemName1, FoodItemName2, ... ]: [ Action, ResultItem ]
const recipes = {
	[ "Lettuce", "CutCarrot", "CutCookedChicken" ]: [ actions.MIX, preload("res://Scenes/Item/FoodItem/chicken_salad.tscn") ],
	
}
