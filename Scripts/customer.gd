extends CharacterBody2D
class_name Customer


signal done_moving

@onready var main: Main = get_tree().get_root().get_node("Main")

var aStar = AStar2D.new()

var possible_orders = Recipes.recipes.values().map( func(x): return x[1] )
var speed := 50

@export var targetPos: Vector2
var order: FoodItem

@export var inLine: bool = false
var line: Array[Customer]
var lineStart: Vector2

func setTargetPositionInLine():
	var linePosition := line.find(self)
	if linePosition > 0:
		var customerInfront := line[linePosition-1]
		var collisionInfront: CollisionShape2D = customerInfront.find_child("CollisionShape2D")
		targetPos = customerInfront.targetPos + Vector2(0, collisionInfront.shape.get_rect().size.y * 1.1)
	else:
		targetPos = lineStart

func lineUp(startPos: Vector2, customersArray: Array[Customer]):
	lineStart = startPos
	line = customersArray
	inLine = true
	setTargetPositionInLine()

func _ready() -> void:
	lineUp(main.order_pos, main.new_customers)
	order = possible_orders.pick_random().instantiate()


func _process(delta: float) -> void:
	if inLine:
		setTargetPositionInLine()
		
	if targetPos:
		position = position.move_toward(targetPos, speed * delta)
	if position == targetPos:
		done_moving.emit()


func move_to_pos(pos: Vector2) -> void:
	inLine = false
	targetPos = pos
	
	await done_moving


func pickup_item() -> void:
	await move_to_pos(main.pickup_pos)


func leave() -> void:
	await move_to_pos(main.exit_pos)
	await move_to_pos(main.out_pos)
	queue_free()
