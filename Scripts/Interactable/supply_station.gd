extends Interactable
class_name SupplyStation


@export var SuppliedItem: PackedScene


func interact(player: Player):
	if not player.heldItem:
		player.tryAddItemFromScene(SuppliedItem)
		return
	
	if player.heldItem is Plate and player.heldItem.heldItems:
		return
	
	if player.heldItem.name == SuppliedItem.instantiate().name:
		player.heldItem.queue_free()
		player.heldItem = null
