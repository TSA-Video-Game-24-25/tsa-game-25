extends ProcessStation


func try_add_item(item: Item) -> bool:
	if item.CutResult == null:
		return false
	
	return super.try_add_item(item)


func can_process_item() -> bool:
	return heldItem and heldItem.CutResult != null


func process_item() -> void:
	var newItem = heldItem.CutResult.instantiate()
	heldItem.queue_free()
	
	heldItem = newItem
	add_child(newItem)
