extends FoodItem
class_name Plate


var heldItems = []


func tryAddItem(item: FoodItem) -> bool:
	if not can_add_item(item):
		return false
	
	heldItems.append(item)
	item.reparent(self)
	item.position = Vector2.ZERO
	item.scale = Vector2(.5, .5)
	
	set_recipe_result()
	return true


func can_add_item(item: FoodItem) -> bool:
	if item == null:
		return false
	var check_recipe = heldItems + [item]
	
	for recipe in Recipes.recipes.keys():
		if array_has_all(recipe, get_names(check_recipe)):
			return true
	return false


func array_has_all(main, checkItems):
	for item in checkItems:
		if !main.has(item):
			return false
		if checkItems.count(item) != main.count(item):
			return false
	return true


func get_names(list):
	return list.map(
		func(item):
			return item.name
	)
	


func set_recipe_result():
	CutResult = null
	MixResult = null
	CookResult = null
	
	for recipe in Recipes.recipes.keys():
		if not array_has_all(get_names(heldItems), recipe):
			continue
		
		var action = Recipes.recipes[recipe][0]
		var result = Recipes.recipes[recipe][1]
		
		match action:
			Recipes.actions.CUT:
				CutResult = result
			Recipes.actions.MIX:
				MixResult = result
			Recipes.actions.COOK:
				CookResult = result
			Recipes.actions.AUTO:
				var parent = get_parent()
				var new_item = result.instantiate()
				
				parent.add_item(new_item)
				
				queue_free()
