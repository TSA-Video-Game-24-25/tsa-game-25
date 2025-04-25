extends Control
class_name UI


@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var DayStart = $DayStart
@onready var DayEnd = $DayEnd
@onready var Tutorial = $GameTutorial
@onready var DifficultySelect = $DifficultySelect
@onready var ScoresMenu = $ScoresMenu
@onready var TopPanel = $Overlay/TopPanel
@onready var QuotaBar = $Overlay/TopPanel/Panel/VBoxContainer/QuotaBar
@onready var OvertimeBar = $Overlay/TopPanel/Panel/VBoxContainer/OvertimeBar
@onready var NextDishSprite = $Overlay/TopPanel/Panel/VBoxContainer/HBoxContainer/Panel/Control/AnimatedSprite2D


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
	$Overlay/TopRightPanel/VBoxContainer/HBoxContainer/Panel/DayLabel.text = "Day " + str(main.day_num)
	$Overlay/TopRightPanel/VBoxContainer/HBoxContainer/Panel3/ScoreLabel.text = "Score: " + str(main.score)
	
	$Overlay/BottomPanel/HBoxContainer/Player1/VBoxContainer/GrabLabel1.visible = main.Players[0].can_grab()
	$Overlay/BottomPanel/HBoxContainer/Player1/VBoxContainer/UseLabel1.visible = main.Players[0].can_use()
	
	$Overlay/BottomPanel/HBoxContainer/Player2/VBoxContainer/GrabLabel2.visible = main.Players[1].can_grab()
	$Overlay/BottomPanel/HBoxContainer/Player2/VBoxContainer/UseLabel2.visible = main.Players[1].can_use()
	
	$Overlay/TopRightPanel/VBoxContainer/NotificationHolder.visible = !$Overlay/TopRightPanel/VBoxContainer/NotificationHolder.get_children().is_empty()
	
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
	main.start()
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


func expand_panel(panel: Control, new_scale: float, time: float):
	var scale_vec = Vector2.ONE * new_scale
	var tween = create_tween()
	
	tween.tween_property(panel, "scale", scale_vec, time)
	tween.tween_property(panel, "scale", Vector2.ONE, time)
	tween.play()
	
	await tween.finished
	tween.kill()


func push_notification(text: String):
	var notif := Notification.create_notif(text)
	var notif_holder = $Overlay/TopRightPanel/VBoxContainer/NotificationHolder
	notif_holder.add_child(notif)
	notif_holder.move_child(notif, 0)
	
	var panel = main.ui.get_node("Overlay/TopRightPanel")
	panel.scale = Vector2.ONE
	
	var tween = create_tween()
	
	tween.tween_property(panel, "scale", Vector2(1.1, 1.1), .5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(panel, "scale", Vector2.ONE, .5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(notif, "modulate", Color(1, 1, 1, .2), 10)
	tween.play()

	await tween.finished
	
	notif.queue_free()


func overtime(time):
	OvertimeBar.max_value = time
	QuotaBar.visible = false
	OvertimeBar.visible = true
	
	$Overlay/TopPanel/Panel/VBoxContainer/HBoxContainer/RichTextLabel.text = "Score as much as possible!"
	$Overlay/TopPanel/Panel/VBoxContainer/HBoxContainer/Panel.visible = false
	
	expand_panel(TopPanel, 1.5, 0.75)


func quota(sprite_frames):
	NextDishSprite.sprite_frames = sprite_frames
	
	$Overlay/TopPanel/Panel/VBoxContainer/HBoxContainer/RichTextLabel.text = "Fill the bar to unlock:"
	$Overlay/TopPanel/Panel/VBoxContainer/HBoxContainer/Panel.visible = true
	
	expand_panel(TopPanel, 1.5, 0.75)
