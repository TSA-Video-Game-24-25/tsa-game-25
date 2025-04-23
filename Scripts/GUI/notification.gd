extends Control
class_name Notification


static var scene := preload("res://Scenes/GUI/notification.tscn")


static func create_notif(text) -> Notification:
	var instance: Notification = scene.instantiate()
	
	instance.get_node("RichTextLabel").text = text
	
	return instance
