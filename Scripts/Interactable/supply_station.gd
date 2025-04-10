extends Interactable
class_name SupplyStation


@export var SuppliedItem: PackedScene

@export var enabled = true:
	set(x):
		enabled = x
		visible = x
		can_interact = x


func interact(player: Player):
	if player.heldItem and player.heldItem.name == SuppliedItem.instantiate().name and not (player.heldItem is Plate):
		player.heldItem.queue_free()
		player.heldItem = null
	else:
		player.tryAddItemFromScene(SuppliedItem)
