extends Item
class_name FoodItem


@export var MixResult: PackedScene
@export var CutResult: PackedScene
@export var CookResult: PackedScene
@export var StoveResult: PackedScene
@export var CookTime: int = 5
@export var IsDone := false
@export var Score := 0


func _ready() -> void:
	if IsDone:
		main.item_processed.emit(name)
