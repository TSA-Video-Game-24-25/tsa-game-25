extends CharacterBody2D
class_name Customer


signal done_moving

const SPEED := 50
const NEW_DISH_CHANCE := .4

@export var targetPos: Vector2

@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var baseUi := main.get_node("Ui/Overlay/VBoxContainer/base")

var customerUi: Control
var order: FoodItem

var inLineVertical: bool = false
var inLineHorizontal: bool = false
var line: Array[Customer]
var lineStart: Vector2

var time_left: float = 0


func _ready() -> void:
	main.start_game.connect(delete)
	
	set_animation()
	
	await move_to_pos(main.exit_pos)
	
	if self in main.new_customers:
		lineUpVertical(main.order_pos, main.new_customers)


func _process(delta: float) -> void:
	if main.paused:
		return
	
	if inLineVertical or inLineHorizontal:
		setTargetPositionInLine()
		
	if targetPos:
		position = position.move_toward(targetPos, SPEED * delta)
	if position == targetPos:
		done_moving.emit()
	
	if not $ProgressBar.visible:
		return
	
	time_left -= delta
	$ProgressBar.value = time_left
	
	if time_left <= 0:
		leave()


func set_animation():
	var animations = $AnimatedSprite2D.sprite_frames.get_animation_names()
	if randf() < .02:
		$AnimatedSprite2D.animation = animations[animations.size() - 1]
	else:
		$AnimatedSprite2D.animation = animations[randi_range(0, animations.size() - 2)]


func set_order():
	if len(main.available_dishes) == 1 or randf() <= NEW_DISH_CHANCE:
		order = main.available_dishes[-1].instantiate()
	else:
		order = main.available_dishes.pick_random().instantiate()
	
	time_left = order.ServeTime
	$ProgressBar.max_value = time_left
	add_to_ui()


func add_to_ui() -> void:
	customerUi = baseUi.duplicate()
	baseUi.get_parent().add_child(customerUi)
	
	customerUi.get_child(1).animation = $AnimatedSprite2D.animation
	customerUi.visible = true
	
	var orderSpriteframes = order.find_child("AnimatedSprite2D")
	if orderSpriteframes != null:
		var foodFrame:AnimatedSprite2D = customerUi.get_child(2)
		var clonedFrame:AnimatedSprite2D = orderSpriteframes.duplicate()
		clonedFrame.global_scale = foodFrame.global_scale
		clonedFrame.position = foodFrame.position
		customerUi.add_child(clonedFrame)
		
	else:
		print(order.name, " does not have a spriteframe!")
		
	customerUi.get_child(1).animation = $AnimatedSprite2D.animation
	customerUi.visible = true


func setTargetPositionInLine():
	var linePosition := line.find(self)
	if linePosition > 0:
		var customerInfront := line[linePosition-1]
		var collisionInfront: CollisionShape2D = customerInfront.find_child("CollisionShape2D")
		targetPos = customerInfront.targetPos + Vector2(
			collisionInfront.shape.get_rect().size.x * 1.1 if inLineHorizontal else 0.0,
			collisionInfront.shape.get_rect().size.y * 1.1 if inLineVertical else 0.0
		)
	else:
		targetPos = lineStart


func lineUpVertical(startPos: Vector2, customersArray: Array[Customer]):
	lineStart = startPos
	line = customersArray
	inLineVertical = true
	inLineHorizontal = false
	setTargetPositionInLine()


func lineUpHorizontal(startPos: Vector2, customersArray: Array[Customer]):
	lineStart = startPos
	line = customersArray
	inLineHorizontal = true
	inLineVertical = false
	setTargetPositionInLine()
	if main.difficulty >= 0:
		$ProgressBar.visible = true


func move_to_pos(pos: Vector2) -> void:
	inLineVertical = false
	inLineHorizontal = false
	targetPos = pos
	
	await done_moving


func pickup_item() -> void:
	main.waiting_customers.erase(self)
	
	await move_to_pos(main.pickup_pos)


func leave() -> void:
	inLineVertical = false
	inLineHorizontal = false
	
	customerUi.queue_free()
	$ProgressBar.visible = false
	
	await move_to_pos(main.exit_pos)
	await move_to_pos(main.out_pos)
	queue_free()


func delete() -> void:
	if customerUi:
		customerUi.queue_free()
	queue_free()
