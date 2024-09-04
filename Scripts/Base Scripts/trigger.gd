extends Node2D


@export_node_path() var Triggerables: Array[NodePath]
@export var Enabled := true
@export var TriggerVal := true
@export var DeleteOnTrigger := false
# || trigger once when condition just changed to true 
# \/ instead of triggering any time condition is true
@export var TriggerOnce := true

@onready var main := get_node("/root/Main")

var state := false


func trigger(_trigger: bool):
	for triggerable_path in Triggerables:
		if not triggerable_path:
			triggerable_path = ''
		var triggerable = get_node_or_null(triggerable_path)
		if not triggerable:
			continue
		triggerable.trigger(_trigger)
	if DeleteOnTrigger:
		queue_free()


func condition():
	pass


func _process(_delta):
	if not Enabled:
		return
	if !condition():
		state = false
		return
	if state and TriggerOnce:
		return
		
	trigger(TriggerVal)
	state = true
	
	
