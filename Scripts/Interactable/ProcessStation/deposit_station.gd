extends "res://Scripts/Interactable/process_station.gd"


@onready var main: Main = get_tree().get_root().get_node("Main")
var customer: Customer


func try_add_item(item: Item) -> bool:
	if not item.IsDone:
		return false
	
	return super.try_add_item(item)


func can_process_item() -> bool:
	if not heldItem:
		return false
	
	for _customer in main.waiting_customers:
		if heldItem.get_class() == _customer.order.get_class():
			customer = _customer
			return true
	return false


func process_item() -> void:
	main.waiting_customers.erase(customer)
	await customer.pickup_item()
	
	heldItem.queue_free()
	heldItem = null
	
	customer.leave()
