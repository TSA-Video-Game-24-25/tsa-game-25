extends Control
class_name UI


@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var DayStart = $DayStart
@onready var DayEnd = $DayEnd

const DayStartStr = "Day %d\n%d Total Pts"
const DayEndStr = "Day %d\n%d Earned Pts\n%d Total Pts\n"


func _process(delta: float) -> void:
	$CanvasLayer/TopPanel/HBoxContainer/Panel/DayLabel.text = "Day " + str(main.day_num)
	$CanvasLayer/TopPanel/HBoxContainer/Panel2/TimeLabel.text = str(snapped(main.time_remaining, .1))
	$CanvasLayer/TopPanel/HBoxContainer/Panel3/ScoreLabel.text = "Score: " + str(main.score)
	
	$CanvasLayer/BottomPanel/HBoxContainer/Player1/VBoxContainer/GrabLabel1.visible = main.Players[0].can_grab()
	$CanvasLayer/BottomPanel/HBoxContainer/Player1/VBoxContainer/UseLabel1.visible = main.Players[0].can_use()
	
	$CanvasLayer/BottomPanel/HBoxContainer/Player2/VBoxContainer/GrabLabel2.visible = main.Players[1].can_grab()
	$CanvasLayer/BottomPanel/HBoxContainer/Player2/VBoxContainer/UseLabel2.visible = main.Players[1].can_use()


func startDay() -> void:
	$DayStart/PanelContainer/Label.text = DayStartStr % [main.day_num, main.total_score]
	$DayStart.visible = true
	
	await get_tree().create_timer(2.0).timeout
	DayStart.visible = false
	return


func endDay() -> void:
	$DayEnd/PanelContainer/VBoxContainer/Label.text = DayEndStr % [main.day_num, main.score, main.total_score]
	$DayEnd.visible = true
	
	var dayEndBtn: Button = $DayEnd/PanelContainer/VBoxContainer/Button
	await dayEndBtn.pressed
	$DayEnd.visible = false
	main.start_day()
	return
