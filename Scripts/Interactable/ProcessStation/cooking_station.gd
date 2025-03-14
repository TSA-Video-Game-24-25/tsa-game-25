extends "res://Scripts/Interactable/process_station.gd"


@export var CookSpeedMult := 1.0
var cook_time := 0.0


func try_add_item(item: FoodItem) -> bool:
	if not item.CookResult:
		return false
	
	return super.try_add_item(item)


func _on_add_item():
	cook_time = heldItem.CookTime
	$ProgressBar.max_value = cook_time


func _process(delta: float) -> void:
	$ProgressBar.visible = $ProgressBar.value
	
	if heldItem == null:
		return
	
	if not heldItem.CookResult:
		return
	
	cook_time = max(0, cook_time - delta * CookSpeedMult)
	$ProgressBar.value = $ProgressBar.max_value - cook_time
	
	if not cook_time == 0:
		return
	
	var newItem = heldItem.CookResult.instantiate()
	heldItem.queue_free()
	
	heldItem = newItem
	add_child(heldItem)
	
	$ProgressBar.value = 0
