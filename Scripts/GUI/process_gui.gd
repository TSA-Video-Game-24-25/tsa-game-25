extends Control


enum action {
	UP,
	LEFT,
	DOWN,
	RIGHT,
}
var action_to_string = {
	action.UP: "move_up",
	action.LEFT: "move_left",
	action.DOWN: "move_down",
	action.RIGHT: "move_right",
}

@export var actionList: Array[action]

var done := false


func _process(_delta: float) -> void:
	if $AnimatedSprite2D.frame >= len(actionList):
		done = true
		get_parent().finish_processing()
		queue_free()
		return
		
	var currAction := actionList[$AnimatedSprite2D.frame]
	
	$Control/Up.visible = currAction == action.UP
	$Control/Left.visible = currAction == action.LEFT
	$Control/Down.visible = currAction == action.DOWN
	$Control/Right.visible = currAction == action.RIGHT
	
	if not Input.is_action_just_pressed(action_to_string[currAction]):
		return
	
	$AnimatedSprite2D.frame += 1
