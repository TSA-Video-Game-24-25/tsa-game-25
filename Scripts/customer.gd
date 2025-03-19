extends CharacterBody2D
class_name Customer


signal done_moving

@onready var main: Main = get_tree().get_root().get_node("Main")

var aStar = AStar2D.new()

var possible_orders = Recipes.recipes.values().map( func(x): return x[1] )
var speed := 50

var targetPos: Vector2
var order: FoodItem


func _ready() -> void:
	order = possible_orders.pick_random().instantiate()
	targetPos = main.order_pos


func _process(delta: float) -> void:
	if targetPos:
		position = position.move_toward(targetPos, speed * delta)
	if position == targetPos:
		done_moving.emit()


func move_to_pos(pos: Vector2) -> void:
	targetPos = pos
	
	await done_moving


func pickup_item() -> void:
	await move_to_pos(main.pickup_pos)


func leave() -> void:
	await move_to_pos(main.exit_pos)
	await move_to_pos(main.out_pos)
	queue_free()
