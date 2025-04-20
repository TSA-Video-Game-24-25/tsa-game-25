extends Node2D
class_name Kitchen


@export var DISHES: Dictionary[PackedScene, int]
var dishes: Dictionary[PackedScene, int]

func reset():
	dishes = DISHES
