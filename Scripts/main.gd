extends Node2D
class_name Main


@export var Players := []
@export var CameraMode := cameraMode.DEFAULT

@export var new_customers: Array[Customer] = []
@export var waiting_customers: Array[Customer] = []

@onready var order_pos: Vector2 = $Kitchen/CustomerOrderPos.position
@onready var pickup_pos: Vector2 = $Kitchen/CustomerPickupPos.position
@onready var exit_pos: Vector2 = $Kitchen/CustomerExitPos.position
@onready var out_pos: Vector2 = $Kitchen/CustomerOutPos.position

var day_num := 1
var score := 0

enum cameraMode {
	DEFAULT,
	FOLLOW_PLAYER_1,
	NONE,
}


func _ready() -> void:
	for x in range(3):
		var new_customer = load("res://Scenes/Customer.tscn").instantiate()
		new_customer.position = Vector2(50, 150 + (x*50))
		new_customers.append(new_customer)
		add_child(new_customer)
		await new_customer.done_moving


func _process(_delta: float) -> void:
	$Camera2D.global_position = get_camera_pos()


func get_available_recipes() -> Array[PackedScene]:
	var available_recipes: Array[PackedScene] = [
		preload("res://Scenes/Item/FoodItem/fried_chicken.tscn"),
		preload("res://Scenes/Item/FoodItem/chicken_salad.tscn"),
	]
	
	if day_num >= 2:
		available_recipes.append( preload("res://Scenes/Item/FoodItem/pizza.tscn") )
	if day_num >= 3:
		available_recipes.append( preload("res://Scenes/Item/FoodItem/spaghetti.tscn") )
	if day_num >= 4:
		available_recipes.append( preload("res://Scenes/Item/FoodItem/chicken_sandwich.tscn") )
	if day_num >= 5:
		available_recipes.append( preload("res://Scenes/Item/FoodItem/tuscan_chicken_pasta.tscn") )
	
	return available_recipes


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
