extends "res://Scripts/Base Scripts/triggerable.gd"


func onTriggerAny(_trigger):
	$ColorRect.color = Color(randf(), randf(), randf()) if _trigger else Color.WHITE
