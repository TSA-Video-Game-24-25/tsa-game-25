extends Node2D
class_name Main


@export var Players := []
@export var CameraMode := cameraMode.DEFAULT

@onready var order_pos: Vector2 = $Kitchen/CustomerOrderPos.position
@onready var pickup_pos: Vector2 = $Kitchen/CustomerPickupPos.position
@onready var exit_pos: Vector2 = $Kitchen/CustomerExitPos.position
@onready var out_pos: Vector2 = $Kitchen/CustomerOutPos.position

var new_customers: Array[Customer] = []
var waiting_customers: Array[Customer] = []

enum cameraMode {
	DEFAULT,
	FOLLOW_PLAYER_1,
	NONE,
}


func _ready() -> void:
	for x in range(3):
		var new_customer = load("res://Scenes/Customer.tscn").instantiate()
		new_customer.position = Vector2(50, 150 + (x*50))
		add_child(new_customer)
		new_customers.append(new_customer)


func _process(_delta: float) -> void:
	$Camera2D.global_position = get_camera_pos()


func get_camera_pos():
	var new_pos = $Camera2D.position
	
	match CameraMode:
		cameraMode.DEFAULT:
			var added_positions := Vector2.ZERO
			
			for player: Node2D in Players:
				added_positions += player.global_position
			
			new_pos = added_positions / len(Players)
		
		
		cameraMode.FOLLOW_PLAYER_1:
			if not Players: return new_pos
			new_pos = Players[0].global_position
		
	return new_pos
