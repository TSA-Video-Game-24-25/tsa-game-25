extends Interactable
class_name ProcessStation


@export var ProcessGUI: PackedScene

var heldItem: Item = null
var gui = null
var player: Player = null


func try_add_item(item: FoodItem) -> bool:
	if heldItem != null:
		return false
	
	heldItem = item
	
	item.reparent(self)
	item.position = $HoldPos.position
	
	_on_add_item()
	
	return true


func interact(_player: Player) -> void:
	player = _player
	
	if heldItem is Plate and heldItem.tryAddItem(player.heldItem):
		player.heldItem = null
	
	elif player.heldItem is FoodItem and try_add_item(player.heldItem):
		player.heldItem = null
	
	elif player.tryAddItem(heldItem):
		heldItem = null


func process(_player: Player):
	if not can_process_item():
		return
	
	if gui != null:
		return
	
	if heldItem == null:
		return
	
	player = _player
	
	if ProcessGUI:
		player.canMove = false
		gui = ProcessGUI.instantiate()
		gui.player = player
		add_child(gui)
	else:
		finish_processing()


func finish_processing():
	player.canMove = true
	player = null
	process_item()


func process_item():
	pass


func can_process_item() -> bool:
	return false


func _on_add_item():
	pass
