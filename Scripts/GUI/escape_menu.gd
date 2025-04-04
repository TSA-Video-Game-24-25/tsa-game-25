extends CanvasLayer


const open_cooldown = 2

@export var PageColors: Array[page_color]

@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var ui: UI = get_parent()

var cooldown := 0.0
var page := 0

enum page_color {
	BLUE,
	PURPLE,
	GREEN
}

var page_color_string = {
	page_color.BLUE: "blue",
	page_color.PURPLE: "purple",
	page_color.GREEN: "green",
}


func _ready() -> void:
	visibility_changed.connect(func(): if visible: $Control/AnimatedSprite2D.play("open"))
	$LeftButton.pressed.connect(turn_page_left)
	$RightButton.pressed.connect(turn_page_right)
	$QuitButton.pressed.connect(func(): main.end_game(); visible = false)


func _process(delta: float) -> void:
	cooldown = max(0, cooldown - delta)
	
	if Input.is_action_just_pressed("open_menu") and (visible or not main.paused) and not (ui.ScoresMenu.visible or ui.DifficultySelect.visible):
		if !visible and cooldown > 0:
			return
		cooldown = open_cooldown
		visible = !visible
		main.paused = visible
	
	$QuitButton.visible = !get_parent().get_node("MainMenu").visible
	
	if not visible:
		return
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_left")):
			turn_page_left()
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_right")):
			turn_page_right()
	
	$Control/AnimatedSprite2D2.frame = page
	$Control/AnimatedSprite2D2.visible = !$Control/AnimatedSprite2D.is_playing()


func turn_page_left():
	$LeftButton.release_focus()
	if page >= 1:
		$Control/AnimatedSprite2D.play_backwards(page_color_string[PageColors[page-1]] + "_to_" + page_color_string[PageColors[page]])
		page -= 1


func turn_page_right():
	$RightButton.release_focus()
	if page <= len(PageColors) - 2:
		$Control/AnimatedSprite2D.play( page_color_string[PageColors[page]] + "_to_" + page_color_string[PageColors[page+1]])
		page += 1
