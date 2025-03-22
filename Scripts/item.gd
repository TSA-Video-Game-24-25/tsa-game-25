extends Node2D
class_name Item


@export var Pickupable = true

@onready var main: Main = get_tree().get_root().get_node("Main")


func _ready() -> void:
	main.day_starting.connect(delete)


func delete() -> void:
	queue_free()
	get_parent().heldItem = null
