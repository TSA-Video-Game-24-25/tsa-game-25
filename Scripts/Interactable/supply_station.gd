extends Interactable
class_name SupplyStation


@export var SuppliedItem: PackedScene

@export var enabled = true:
	set(x):
		enabled = x
		visible = x
		can_interact = x


func interact(player: Player):
	if not player.heldItem:
		player.tryAddItemFromScene(SuppliedItem)
		return
	
	if player.heldItem is Plate and player.heldItem.heldItems:
		return
	
	if player.heldItem.name == SuppliedItem.instantiate().name:
		player.heldItem.queue_free()
		player.heldItem = null
