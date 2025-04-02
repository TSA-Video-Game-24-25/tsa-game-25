extends Interactable


func interact(player):
	if not player.heldItem:
		return
	
	player.heldItem.queue_free()
	player.heldItem = null
