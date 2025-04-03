extends Control
class_name UI


@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var DayStart = $DayStart
@onready var DayEnd = $DayEnd
@onready var Tutorial = $GameTutorial
@onready var DifficultySelect = $DifficultySelect
@onready var ScoresMenu = $ScoresMenu


const DayStartStr = "Day %d\nScore: %d"
const DayEndStr = "Day %d\nEarned %d Points\nCurrent Score: %d\n"
const GameEndStr = "Game Over\nEarned %d Points\nFinal Score: %d\n"


func _ready() -> void:
	$MainMenu.visible = true
	$Overlay.visible = true
	
	$MainMenu/VBoxContainer/PlayButton.pressed.connect(func(): $DifficultySelect.visible = true; $MainMenu/VBoxContainer/PlayButton.release_focus())
	$MainMenu/VBoxContainer/CookbookButton.pressed.connect(func(): $EscapeMenu.visible = true; $MainMenu/VBoxContainer/CookbookButton.release_focus())
	$MainMenu/VBoxContainer/TutorialButton.pressed.connect(func(): $Tutorial.visible = true; $MainMenu/VBoxContainer/TutorialButton.release_focus())
	$MainMenu/ScoresButton.pressed.connect(show_scores_menu)
	
	$DifficultySelect/PanelContainer/VBoxContainer/Tutorial.pressed.connect(start_game.bind(-1))
	$DifficultySelect/PanelContainer/VBoxContainer/Beginner.pressed.connect(start_game.bind(0))
	$DifficultySelect/PanelContainer/VBoxContainer/Normal.pressed.connect(start_game.bind(1))


func _process(_delta: float) -> void:
	$Overlay/TopPanel/HBoxContainer/Panel/DayLabel.text = "Day " + str(main.day_num)
	$Overlay/TopPanel/HBoxContainer/Panel2/VBoxContainer/TimeLabel.text = str(snapped(main.time_remaining, .1))
	$Overlay/TopPanel/HBoxContainer/Panel3/ScoreLabel.text = "Score: " + str(main.score)
	
	$Overlay/BottomPanel/HBoxContainer/Player1/VBoxContainer/GrabLabel1.visible = main.Players[0].can_grab()
	$Overlay/BottomPanel/HBoxContainer/Player1/VBoxContainer/UseLabel1.visible = main.Players[0].can_use()
	
	$Overlay/BottomPanel/HBoxContainer/Player2/VBoxContainer/GrabLabel2.visible = main.Players[1].can_grab()
	$Overlay/BottomPanel/HBoxContainer/Player2/VBoxContainer/UseLabel2.visible = main.Players[1].can_use()
	
	if Input.is_action_just_pressed("open_menu"):
		if $ScoresMenu.visible:
			$ScoresMenu.visible = false
		if $DifficultySelect.visible:
			$DifficultySelect.visible = false


func startDay() -> void:
	$DayStart/PanelContainer/Label.text = DayStartStr % [main.day_num, main.total_score]
	$DayStart.visible = true
	$MainMenu.visible = false
	
	await get_tree().create_timer(2.0).timeout
	DayStart.visible = false


func endDay() -> void:
	$DayEnd/PanelContainer/VBoxContainer/Label.text = DayEndStr % [main.day_num, main.score, main.total_score]
	$DayEnd.visible = true
	
	if main.difficulty == 1:
		var file: ConfigFile = ConfigFile.new()
		file.load("user://data")
		
		var score = file.get_value("scores", "day%d" % main.day_num) if file.has_section_key("scores", "day%d" % main.day_num) else 0 #w
		if score < main.score:
			file.set_value("scores", "day%d" % main.day_num, main.score)
		file.save("user://data")
	
	var dayEndBtn: Button = $DayEnd/PanelContainer/VBoxContainer/Button
	await dayEndBtn.pressed
	$DayEnd.visible = false
	main.start_day()


func start_game(difficulty):
	main.difficulty = difficulty
	main.start_day()
	$DifficultySelect.visible = false
	$MainMenu.visible = false


func endGame() -> void:
	$GameEnd/PanelContainer/VBoxContainer/Label.text = GameEndStr % [main.score, main.total_score]
	$GameEnd.visible = true
	
	if main.difficulty == 1:
		var file: ConfigFile = ConfigFile.new()
		file.load("user://data")
		
		var score = file.get_value("scores", "day%d" % main.day_num) if file.has_section_key("scores", "day%d" % main.day_num) else 0 #w
		if score < main.score:
			file.set_value("scores", "day%d" % main.day_num, main.score)
		file.save("user://data")
		
		var final_score = file.get_value("scores", "final") if file.has_section_key("scores", "final") else 0 #w
		if final_score < main.total_score:
			file.set_value("scores", "final", main.total_score)
		file.save("user://data")
	
	var gameEndBtn: Button = $GameEnd/PanelContainer/VBoxContainer/Button
	await gameEndBtn.pressed
	
	$GameEnd.visible = false
	$MainMenu.visible = true
	main.restart_game()


func show_scores_menu():
	$ScoresMenu/PanelContainer/Scores.text = ""
	
	var file: ConfigFile = ConfigFile.new()
	file.load("user://data")
		
	for x in range(1, 6):
		if file.has_section_key("scores", "day%d" % x):
			var score = file.get_value("scores", "day%d" % x)
			$ScoresMenu/PanelContainer/Scores.text += "Day %s High: %d\n" % [x, score]
	
	if file.has_section_key("scores", "final"):
		var score = file.get_value("scores", "final")
		$ScoresMenu/PanelContainer/Scores.text += "\nFinal High: %d" % [score]
	
	if not $ScoresMenu/PanelContainer/Scores.text:
		$ScoresMenu/PanelContainer/Scores.text = "You currently have no saved scores."
	
	$ScoresMenu.visible = true
	$MainMenu/ScoresButton.release_focus()
