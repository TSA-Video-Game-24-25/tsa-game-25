extends "res://Scripts/Base Scripts/trigger.gd"


@export var OverlappingBodies := []


func _ready():
	connect("body_entered", _body_entered)
	connect("body_exited", _body_exited)


func _body_entered(body):
	OverlappingBodies.append(body)

func _body_exited(body):
	OverlappingBodies.erase(body)


func condition():
	for body in OverlappingBodies:
		if not body is Player:
			return
		
		var action = body.get_input("interact")
		
		if Input.is_action_pressed(action):
			return true
	return false
