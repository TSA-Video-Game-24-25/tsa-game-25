extends CanvasLayer


@onready var main: Main = get_tree().get_root().get_node("Main")

var page = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		visible = !visible
	
	if not visible:
		return
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_left")) and page > 1:
			pass
