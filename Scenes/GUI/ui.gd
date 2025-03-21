extends Control


@onready var main: Main = get_tree().get_root().get_node("Main")


func _process(delta: float) -> void:
	$CanvasLayer/Panel/HBoxContainer/Panel/DayLabel.text = "Day " + str(main.day_num)
	$CanvasLayer/Panel/HBoxContainer/Panel2/TimeLabel.text = str(snapped(main.time_remaining, .1))
	$CanvasLayer/Panel/HBoxContainer/Panel3/ScoreLabel.text = "Score: " + str(main.score)


func startDay() -> void:
	return


func endDay() -> void:
	return
