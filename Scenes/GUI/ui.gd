extends Control
class_name UI


@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var DayStart = $DayStart
@onready var DayEnd = $DayEnd

const DayStartStr = "Day %d\n%d Total Pts"
const DayEndStr = "Day %d\n%d Earned Pts\n%d Total Pts"


func _process(delta: float) -> void:
	$CanvasLayer/Panel/HBoxContainer/Panel/DayLabel.text = "Day " + str(main.day_num)
	$CanvasLayer/Panel/HBoxContainer/Panel2/TimeLabel.text = str(snapped(main.time_remaining, .1))
	$CanvasLayer/Panel/HBoxContainer/Panel3/ScoreLabel.text = "Score: " + str(main.score)


func startDay() -> void:
	DayStart.find_child("Label").text = DayStartStr % [main.day_num, main.total_score]
	DayStart.visible = true
	await get_tree().create_timer(2.0).timeout
	DayStart.visible = false
	return


func endDay() -> void:
	DayEnd.find_child("Label").text = DayEndStr % [main.day_num, main.score, main.total_score]
	DayEnd.visible = true
	await get_tree().create_timer(2.0).timeout
	DayEnd.visible = false
	return
