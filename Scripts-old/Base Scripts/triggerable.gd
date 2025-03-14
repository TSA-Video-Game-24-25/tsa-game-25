extends Node2D
class_name Triggerable


@export var State = false
@onready var main = get_node("/root/Main")


func trigger(_trigger: bool):
	onTriggerAny(_trigger)
	
	if State == _trigger: return
	onTrigger(_trigger)


func onTriggerAny(_trigger: bool):
	pass

func onTrigger(_trigger: bool):
	pass
