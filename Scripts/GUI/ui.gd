extends Control
class_name UI


@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var DayStart = $DayStart
@onready var DayEnd = $DayEnd

const DayStartStr = "Day %d\nScore: %d"
const DayEndStr = "Day %d\nEarned %d Points\nCurrent Score: %d\n"


func _ready() -> void:
	$MainMenu.visible = true
	$Overlay.visible = true
	$MainMenu/VBoxContainer/CookbookButton.pressed.connect(func(): $EscapeMenu.visible = true; $MainMenu/VBoxContainer/CookbookButton.release_focus())


func _process(_delta: float) -> void:
	$Overlay/TopPanel/HBoxContainer/Panel/DayLabel.text = "Day " + str(main.day_num)
	$Overlay/TopPanel/HBoxContainer/Panel2/TimeLabel.text = str(snapped(main.time_remaining, .1))
	$Overlay/TopPanel/HBoxContainer/Panel3/ScoreLabel.text = "Score: " + str(main.score)
	
	$Overlay/BottomPanel/HBoxContainer/Player1/VBoxContainer/GrabLabel1.visible = main.Players[0].can_grab()
	$Overlay/BottomPanel/HBoxContainer/Player1/VBoxContainer/UseLabel1.visible = main.Players[0].can_use()
	
	$Overlay/BottomPanel/HBoxContainer/Player2/VBoxContainer/GrabLabel2.visible = main.Players[1].can_grab()
	$Overlay/BottomPanel/HBoxContainer/Player2/VBoxContainer/UseLabel2.visible = main.Players[1].can_use()


func startDay() -> void:
	$DayStart/PanelContainer/Label.text = DayStartStr % [main.day_num, main.total_score]
	$DayStart.visible = true
	$MainMenu.visible = false
	
	await get_tree().create_timer(2.0).timeout
	DayStart.visible = false


func endDay() -> void:
	$DayEnd/PanelContainer/VBoxContainer/Label.text = DayEndStr % [main.day_num, main.score, main.total_score]
	$DayEnd.visible = true
	
	var dayEndBtn: Button = $DayEnd/PanelContainer/VBoxContainer/Button
	await dayEndBtn.pressed
	$DayEnd.visible = false
	main.start_day()
