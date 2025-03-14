extends FoodItem
class_name Plate


var heldItems = []


func tryAddItem(item: FoodItem) -> bool:
	print(item)
	if not can_add_item(item):
		print("Cant add item")
		return false
	
	heldItems.append(item)
	item.reparent(self)
	item.position = Vector2.ZERO
	item.scale  = Vector2(.5, .5)
	
	try_make_recipe()
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
	print(main)
	print(checkItems)
	for item in checkItems:
		if !main.has(item):
			print("false")
			return false
		if checkItems.count(item) != main.count(item):
			print("false")
			return false
	print("true")
	return true


func get_names(list):
	return list.map(
		func(item):
			return item.name
	)
	


func try_make_recipe():
	for recipe in Recipes.recipes.keys():
		if array_has_all(get_names(heldItems), recipe):
			var new_item = Recipes.recipes[recipe].instantiate()
			var parent = get_parent()
			
			parent.heldItem = new_item
			parent.add_child(new_item)
			
			queue_free()
