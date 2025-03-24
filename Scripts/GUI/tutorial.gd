extends CanvasLayer


@onready var main: Main = get_tree().get_root().get_node("Main")

var frame = 0


func _ready() -> void:
	visibility_changed.connect(func(): frame = 0)
	$LeftButton.pressed.connect(turn_left)
	$RightButton.pressed.connect(turn_right)


func _process(_delta: float) -> void:
	if not visible:
		return
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_left")):
			turn_left()
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_right")):
			turn_right()
	
	$Control/AnimatedSprite2D.frame = frame


func turn_left():
	$LeftButton.release_focus()
	if frame >= 1:
		frame -= 1


func turn_right():
	$RightButton.release_focus()
	if frame <= 5:
		frame += 1
	else:
		visible = false
