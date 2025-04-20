extends "res://Scripts/Interactable/process_station.gd"


var customer: Customer


func _ready() -> void:
	main.start_game.connect(reset)


func try_add_item(item: Item) -> bool:
	if not item.IsDone:
		return false
	
	return super.try_add_item(item)


func can_process_item() -> bool:
	if not heldItem:
		return false
	
	for _customer in main.waiting_customers:
		if heldItem.name == _customer.order.name:
			return true
	return false


func process_item() -> void:
	main.soundPlayer.PlayAtPosition("Bell", position)
	
	for _customer in main.waiting_customers:
		if heldItem.name == _customer.order.name:
			customer = _customer
			break
	
	can_interact = false
	
	await customer.pickup_item()
	
	reset()
	
	customer.leave()
	main.score += customer.order.Score


func reset():
	if heldItem:
		heldItem.queue_free()
		heldItem = null
	can_interact = true
