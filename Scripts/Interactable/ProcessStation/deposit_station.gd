extends "res://Scripts/Interactable/process_station.gd"


func try_add_item(item: Item) -> bool:
	if not item.IsDone:
		return false
	
	return super.try_add_item(item)


func can_process_item() -> bool:
	return true


func process_item() -> void:
	heldItem.queue_free()
	heldItem = null
