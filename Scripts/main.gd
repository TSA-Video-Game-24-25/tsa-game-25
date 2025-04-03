extends Node2D
class_name Main


signal day_starting
signal order_taken
signal item_interact(String)
signal item_process(String)
signal item_processed(String)

@export var Players := []
@export var CameraMode := cameraMode.DEFAULT

@export var new_customers: Array[Customer] = []
@export var waiting_customers: Array[Customer] = []

@onready var order_pos: Vector2 = $Kitchen/CustomerOrderPos.position
@onready var pickup_pos: Vector2 = $Kitchen/CustomerPickupPos.position
@onready var exit_pos: Vector2 = $Kitchen/CustomerExitPos.position
@onready var out_pos: Vector2 = $Kitchen/CustomerOutPos.position

@onready var ui:UI = $Ui
@onready var soundPlayer: SoundPlayer = $SoundPlayer

const tutorial_max_waiting_customers = 1
const normal_max_waiting_customers = 3
const easy_max_waiting_customers = 5

var day_num := 0
var time_remaining: float = 0
var score := 0
var total_score := 0
var paused = true
var difficulty = 0
var max_waiting_customers = 0

enum cameraMode {
	DEFAULT,
	FOLLOW_PLAYER_1,
	NONE,
}


func _ready() -> void:
	for player: Player in Players:
		player.item_interact.connect(func(x): item_interact.emit(x))


func _process(_delta: float) -> void:
	$Camera2D.global_position = get_camera_pos()
	
	for station in [ $Kitchen/CheeseSupplyStation, $Kitchen/TomatoSupplyStation ]:
		station.enabled = (day_num > 1) or (difficulty == -1)
	
	if paused:
		return
	
	if time_remaining == 0:
		return
	
	time_remaining = max( 0, time_remaining - _delta )
	
	if time_remaining == 0:
		if day_num == 5:
			end_game()
		else:
			end_day()


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


func spawn_customer() -> Customer:
	var new_customer = load("res://Scenes/Customer.tscn").instantiate()
	
	new_customers.append(new_customer)
	new_customer.position = $Kitchen/CustomerOutPos.position
	add_child(new_customer)
	
	return new_customer


func spawn_customer_with_order(order: PackedScene) -> Customer:
	var new_customer = spawn_customer()
	new_customer.order = order.instantiate()
	return new_customer


func start_day():
	day_starting.emit()
	
	new_customers = []
	waiting_customers = []
	
	score = 0
	day_num += 1
	ui.startDay()
	
	Players[0].position = $Kitchen/Player1Pos.position
	Players[1].position = $Kitchen/Player2Pos.position
	
	if difficulty == -1:
		$Ui.Tutorial.start_tutorial()
		time_remaining = 0
		max_waiting_customers = tutorial_max_waiting_customers
	if difficulty == 0:
		time_remaining = 200 + (day_num * 30)
		max_waiting_customers = easy_max_waiting_customers
	if difficulty == 1:
		time_remaining = 150 + (day_num * 20)
		max_waiting_customers = normal_max_waiting_customers
	
	paused = false
	
	for player: Player in Players:
		player.canMove = true
	
	if difficulty == -1:
		spawn_customer_with_order(load("res://Scenes/Item/FoodItem/chicken_salad.tscn"))
		spawn_customer_with_order(load("res://Scenes/Item/FoodItem/fried_chicken.tscn"))
	else:
		for x in range(3):
			spawn_customer()
			await get_tree().create_timer(1).timeout


func end_day():
	paused = true
	total_score += score
	
	for player: Player in Players:
		player.canMove = false
	
	ui.endDay()


func end_game():
	paused = true
	total_score += score
	
	for player: Player in Players:
		player.canMove = false
	
	ui.endGame()


func restart_game():
	total_score = 0
	day_num = 0
