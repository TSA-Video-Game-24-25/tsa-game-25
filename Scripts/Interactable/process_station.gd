extends Interactable
class_name ProcessStation


@export var ProcessGUI: PackedScene

@onready var main: Main = get_tree().get_root().get_node("Main")

var heldItem: Item = null
var gui = null
var player: Player = null


func _ready() -> void:
	main.delete_items.connect(func(): if gui: gui.queue_free())


func try_add_item(item: FoodItem) -> bool:
	if heldItem != null:
		return false
	
	add_item(item)
	
	_on_add_item()
	
	return true


func add_item(item: Item):
	heldItem = item
	
	if item.get_parent():
		item.reparent(self)
	else:
		add_child(item)
	
	item.position = $HoldPos.position


func interact(_player: Player) -> void:
	player = _player
	
	if heldItem is Plate and heldItem.tryAddItem(player.heldItem):
		player.item_interact.emit("place_" + player.heldItem.name + "_plate")
		player.heldItem = null
	
	elif player.heldItem is FoodItem and try_add_item(player.heldItem):
		player.item_interact.emit("place_" + player.heldItem.name + "_" + name)
		player.heldItem = null
	
	elif not heldItem.GrabRemainder and player.tryAddItem(heldItem):
		player.item_interact.emit("grab_" + heldItem.name)
		heldItem = null
	elif heldItem.GrabRemainder and player.tryAddItem(heldItem.GrabPiece):
		player.item_interact.emit("grab_" + heldItem.GrabPiece.name)
		heldItem = heldItem.GrabRemainder


func process(_player: Player):
	if not can_process_item():
		return
	
	if gui != null:
		return
	
	if heldItem == null:
		return
	
	player = _player
	
	main.item_process.emit(heldItem.name + "_" + name)
	
	if ProcessGUI:
		can_interact = false
		player.canMove = false
		gui = ProcessGUI.instantiate()
		gui.player = player
		add_child(gui)
	else:
		finish_processing()


func finish_processing():
	can_interact = true
	player.canMove = true
	player = null
	process_item()
	main.item_processed.emit(heldItem.name + "_" + name)


func process_item():
	pass


func can_process_item() -> bool:
	return false


func _on_add_item():
	pass
