extends Node2D
class_name Main


signal start_game
signal delete_items
signal order_taken
signal item_interact(String)
signal item_process(String)
signal item_processed(String)
signal quota_reached
signal overtime_end

@export var Players := []
@export var CameraMode := cameraMode.DEFAULT

@export var new_customers: Array[Customer] = []
@export var waiting_customers: Array[Customer] = []

@onready var kitchen: Kitchen = $Kitchen/Kitchen1
@onready var ui: UI = $Ui
@onready var soundPlayer: SoundPlayer = $SoundPlayer

@onready var order_pos: Vector2 = kitchen.get_node("CustomerOrderPos").position
@onready var pickup_pos: Vector2 = kitchen.get_node("CustomerPickupPos").position
@onready var exit_pos: Vector2 = kitchen.get_node("CustomerExitPos").position
@onready var out_pos: Vector2 = kitchen.get_node("CustomerOutPos").position

const tutorial_max_waiting_customers = 1
const normal_max_waiting_customers = 3
const easy_max_waiting_customers = 5

var day_num := 0
var time_remaining: float = 0
var score := 0
var day_score := 0
var paused = true
var difficulty = 0
var max_waiting_customers = 0
var quota = 0
var remaining_lives = 0

var available_dishes: Array = []
var game_state: gameState = gameState.QUOTA

enum gameState {
	QUOTA,
	OVERTIME,
}

enum cameraMode {
	DEFAULT,
	FOLLOW_PLAYER_1,
	NONE,
}


func _ready() -> void:
	start_game.connect(delete_items.emit)
	for player: Player in Players:
		player.item_interact.connect(func(x): item_interact.emit(x))


func _process(delta: float) -> void:
	$Camera2D.global_position = get_camera_pos()
	
	for station in [ kitchen.get_node("LettuceSupplyStation") ]:
		station.enabled = (day_num > 1) or (difficulty == -1)
	
	for station in [ kitchen.get_node("CheeseSupplyStation"), kitchen.get_node("TomatoSupplyStation") ]:
		station.enabled = (day_num > 2) or (difficulty == -1)
	
	if paused:
		return
	
	if remaining_lives <= 0:
		end_game()
		return
	
	match game_state:
		gameState.QUOTA when score >= quota:
			quota_reached.emit()
			game_state = gameState.OVERTIME
			start_overtime()
		
		gameState.QUOTA:
			ui.QuotaBar.value = score
		
		gameState.OVERTIME when time_remaining <= 0:
			overtime_end.emit()
			game_state = gameState.QUOTA
			start_quota()
		
		gameState.OVERTIME:
			time_remaining -= delta
			ui.OvertimeBar.value = time_remaining


func start_overtime() -> void:
	delete_items.emit()
	time_remaining = 40 + day_num * 25
	
	ui.overtime(time_remaining)


func start_quota() -> void:
	if kitchen.dishes.is_empty():
		end_game()
		return
	
	ui.save_score()
	
	day_num += 1
	day_score = 0
	
	available_dishes.append( kitchen.dishes.keys()[0] )
	kitchen.dishes.erase( kitchen.dishes.keys()[0] )
	
	set_quota()
	ui.quota(kitchen.dishes.keys()[0].instantiate().get_node("AnimatedSprite2D").sprite_frames)


func set_quota() -> void:
	quota = score + kitchen.dishes.values()[0]
	
	ui.QuotaBar.min_value = score
	ui.QuotaBar.max_value = quota
	
	ui.OvertimeBar.visible = false
	ui.QuotaBar.visible = true


func get_camera_pos() -> Vector2:
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
	new_customer.position = kitchen.get_node("CustomerOutPos").position
	add_child(new_customer)
	
	return new_customer


func spawn_customer_with_order(order: PackedScene) -> Customer:
	var new_customer = spawn_customer()
	new_customer.order = order.instantiate()
	return new_customer


func start() -> void:
	kitchen.reset()
	
	for value in kitchen.dishes:
		if kitchen.dishes[value] <= 0:
			available_dishes.append(value)
			kitchen.dishes.erase( kitchen.dishes.keys()[0] )
			continue
		break
	
	set_quota()
	ui.quota(kitchen.DISHES.keys()[0].instantiate().get_node("AnimatedSprite2D").sprite_frames)
	start_game.emit()
	
	new_customers = []
	waiting_customers = []
	
	remaining_lives = 3
	score = 0
	day_num += 1
	ui.startDay()
	
	Players[0].position = kitchen.get_node("Player1Pos").position
	Players[1].position = kitchen.get_node("Player2Pos").position
	
	if difficulty == -1:
		$Ui.Tutorial.start_tutorial()
	
	max_waiting_customers = \
		tutorial_max_waiting_customers if difficulty == -1 else \
		easy_max_waiting_customers if difficulty == 0 else \
		normal_max_waiting_customers
	
	paused = false
	
	for player: Player in Players:
		player.canMove = true
	
	for x in range(3):
		spawn_customer()
		await get_tree().create_timer(1).timeout


func end_game() -> void:
	paused = true
	
	for player: Player in Players:
		player.canMove = false
	
	ui.endGame()
	restart_game()


func restart_game() -> void:
	score = 0
	day_score = 0
	day_num = 0


func lose_life() -> void:
	remaining_lives -= 1
	ui.push_notification("[font_size=20]-1 Life [img]%s[/img]" % "res://Art/UI/New Piskel (1) (2).png")
