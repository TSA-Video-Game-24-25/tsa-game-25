extends CharacterBody2D
class_name Player


const SPEED := 100.0
const ACCELERATION := 800.0
@onready var sprite := $AnimatedSprite2D

var canMove := true

var heldItem: Item
var preferredDirection := Vector2.UP

@export var input_map := {
	"move_up": "w",
	"move_left": "a",
	"move_down": "s",
	"move_right": "d",
	"interact": "e",
	"process": "q",
}:
	set(val):
		input_map = val
		update_input_map()

@onready var main = get_node("/root/Main")

var id: int


func _ready() -> void:
	main.Players.append(self)
	id = len(main.Players)
	
	update_input_map()


func _physics_process(delta: float) -> void:
	if main.paused:
		return
	
	var direction := get_dir()
	
	if direction.length_squared() != 0:
		preferredDirection = direction
	
	if canMove:
		velocity = velocity.move_toward(direction * SPEED, delta * ACCELERATION)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	play_animation()
	
	interact_if_pressed()
	process_if_pressed()


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
	return Input.get_vector(
		get_input("move_left"), 
		get_input("move_right"), 
		get_input("move_up"), 
		get_input("move_down")
	)



func tryAddItemFromScene(item: PackedScene) -> bool:
	if heldItem != null:
		return false
	
	heldItem = item.instantiate()
	add_child(heldItem)
	
	heldItem.position = $HeldItemPos.position
	return true


func tryAddItem(item: Item) -> bool:
	if heldItem != null:
		return false
	
	if item == null:
		return false
	
	if not item.Pickupable:
		return false
	
	heldItem = item
	item.reparent(self)
	
	heldItem.position = $HeldItemPos.position
	return true


func interact_if_pressed() -> void:
	if not Input.is_action_just_pressed(get_input("interact")):
		return
	
	if not canMove:
		return
	
	var overlapping_bodies = $InteractArea.get_overlapping_bodies()
	overlapping_bodies.sort_custom(
		func(a, b):
			return (position + preferredDirection).distance_to(a.position) < (position + preferredDirection).distance_to(b.position)
	)
	
	for body in overlapping_bodies:
		if not body is Interactable:
			continue
		if not body.can_interact:
			continue
		
		body.interact(self)
		return


func process_if_pressed() -> void:
	if not Input.is_action_just_pressed(get_input("process")):
		return
	
	var overlapping_bodies = $InteractArea.get_overlapping_bodies()
	overlapping_bodies.sort_custom(
		func(a, b):
			return (position + preferredDirection).distance_to(a.position) < (position + preferredDirection).distance_to(b.position)
	)
	
	for body in overlapping_bodies:
		if not body is ProcessStation:
			continue
		if not body.can_interact:
			continue
		
		body.process(self)
		return

func play_animation() -> void:
	if velocity == Vector2.ZERO:
		return
	
	if velocity.y > 0: 
		sprite.play("down")
	if velocity.y < 0: 
		sprite.play("up")
	
	if velocity.x > 0: 
		sprite.play("right")
	if velocity.x < 0: 
		sprite.play("left")


func can_grab() -> bool:
	var overlapping_bodies = $InteractArea.get_overlapping_bodies()
	
	overlapping_bodies.sort_custom(
		func(a, b):
			return (position + preferredDirection).distance_to(a.position) < (position + preferredDirection).distance_to(b.position)
	)
	
	for body in overlapping_bodies:
		if not body is Interactable:
			continue
		if not body.can_interact:
			continue
		
		if body is SupplyStation and (heldItem == null or heldItem.name == body.SuppliedItem.instantiate().name):
				return true
			
		if body is ProcessStation:
			if body.heldItem is Plate:
				return true
			if (heldItem and true) != (body.heldItem and true): #xor
				return true
		return false
		
	return false


func can_use() -> bool:
	var overlapping_bodies = $InteractArea.get_overlapping_bodies()
	
	overlapping_bodies.sort_custom(
		func(a, b):
			return (position + preferredDirection).distance_to(a.position) < (position + preferredDirection).distance_to(b.position)
	)
	
	for body in overlapping_bodies:
		if not body is ProcessStation:
			continue
		if not body.can_interact:
			continue
			
		if body.can_process_item():
			return true
		return false
		
	return false
