class_name Recipes


enum actions {
	CUT,
	MIX,
	COOK,
}

const recipes = {
	[ "Lettuce", "CutCarrot", "CutCookedChicken" ]: [ actions.MIX, preload("res://Scenes/Item/FoodItem/chicken_salad.tscn") ],
}
