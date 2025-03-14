extends ProcessStation


func can_process_item() -> bool:
	return heldItem and heldItem.MixResult


func process_item() -> void:
	var newItem = heldItem.MixResult.instantiate()
	heldItem.queue_free()
	
	heldItem = newItem
	add_child(newItem)
