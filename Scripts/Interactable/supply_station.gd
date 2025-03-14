extends Interactable


@export var SuppliedItem: PackedScene


func interact(player: Player):
	player.tryAddItemFromScene(SuppliedItem)
