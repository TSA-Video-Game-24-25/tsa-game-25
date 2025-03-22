extends CanvasLayer


@export var PageColors: Array[page_color]

@onready var main: Main = get_tree().get_root().get_node("Main")

var page = 0

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


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_menu") and (visible or not main.paused):
		visible = !visible
		main.paused = visible
	
	if not visible:
		return
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_left")) and page >= 1:
			$Control/AnimatedSprite2D.play_backwards(page_color_string[PageColors[page-1]] + "_to_" + page_color_string[PageColors[page]])
			page -= 1
	
	for player: Player in main.Players:
		if Input.is_action_just_pressed(player.get_input("move_right")) and page <= len(PageColors)-2:
			$Control/AnimatedSprite2D.play( page_color_string[PageColors[page]] + "_to_" + page_color_string[PageColors[page+1]])
			page += 1
	
	$Control/AnimatedSprite2D2.frame = page
	$Control/AnimatedSprite2D2.visible = !$Control/AnimatedSprite2D.is_playing()
	
