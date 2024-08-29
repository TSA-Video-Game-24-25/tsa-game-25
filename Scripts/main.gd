extends Node2D

@export var Players := []
@export var CameraMode := cameraMode.Default

enum cameraMode {
	Default,
	FollowPlayer1
}


func _process(_delta: float) -> void:
	$Camera2D.global_position = get_camera_pos()


func get_camera_pos():
	var new_pos := Vector2.ZERO
	
	match CameraMode:
		
		cameraMode.Default:
			var added_positions := Vector2.ZERO
			
			for player: Node2D in Players:
				added_positions += player.global_position
			
			new_pos = added_positions / len(Players)
		
		
		cameraMode.FollowPlayer1:
			if not Players: return new_pos
			new_pos = Players[0].global_position
		
	return new_pos
