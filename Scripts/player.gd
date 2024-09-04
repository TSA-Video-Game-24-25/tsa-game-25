extends CharacterBody2D
class_name Player


const SPEED := 400.0
const ACCELERATION := 2000.0

@export var input_map := {
	"move_up": "w",
	"move_left": "a",
	"move_down": "s",
	"move_right": "d",
	"interact": "e",
}:
	set(val):
		input_map = val
		update_input_map()

@onready var main = get_node("/root/Main")

var id: int


func _ready() -> void:
	main.Players.append(self)
	id = len(main.Players)
	$Label.text = str(id)
	
	update_input_map()


func _physics_process(delta: float) -> void:
	var direction := get_dir()
	
	velocity = velocity.move_toward(direction * SPEED, delta * ACCELERATION)

	move_and_slide()


func update_input_map():
	for _action in input_map:
		var action = str(id) + _action
		var key = input_map[_action]
		
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		
		var key_event = InputEventKey.new()
		key_event.keycode = OS.find_keycode_from_string(key)
		
		InputMap.action_add_event(action, key_event)


func get_input(input_str: String) -> String:
	return str(id) + input_str


func get_dir() -> Vector2:
	return Input.get_vector(get_input("move_left"), 
							get_input("move_right"), 
							get_input("move_up"), 
							get_input("move_down"))
