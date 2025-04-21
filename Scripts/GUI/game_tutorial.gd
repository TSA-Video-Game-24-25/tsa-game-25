extends CanvasLayer


signal action_complete

const grab_plate = "[center][font_size=15]Goal:\nEvery dish starts with a plate, grab one from the plate supplier! (E/O)"
const grab_lettuce = "[center][font_size=15]Goal:\nNext we need to grab a piece of lettuce from the lettuce supplier."
const grab_chicken = "[center][font_size=15]Goal:\nNext we need to grab a piece of chicken from the chicken supplier."
const grab_flour = "[center][font_size=15]Goal:\nNext we need to grab a piece of flour from the flour supplier."
const grab_tomato = "[center][font_size=15]Goal:\nNext we need to grab a piece of tomato from the tomato supplier."
const grab_cheese = "[center][font_size=15]Goal:\nNext we need to grab a piece of cheese from the cheese supplier."

const place_counter_mix = "[center][font_size=15]Goal:\nNow place this ingredient on a counter for mixing. (E/O)"
const place_cutting_station = "[center][font_size=15]Goal:\nNow place this ingredient on the cutting board. (E/O)"
const place_plate = "[center][font_size=15]Goal:\nNow place this plate on a counter so you can add the ingredients. (E/O)"
const place_on_plate = "[center][font_size=15]Goal:\nNext add this ingredient to the plate. (E/O)"

const mix_ingredient = "[center][font_size=15]Goal:\nMix the ingredient using the (Q/U) button."
const cut_ingredient = "[center][font_size=15]Goal:\nCut the ingredient using the (Q/U) button."
const stove_ingredient = "[center][font_size=15]Goal:\nThis ingredient needs to be cooked on the stove for this recipe."
const oven_ingredient = "[center][font_size=15]Goal:\nThis ingredient needs to be cooked in the oven for this recipe."
const wait_for_cook = "[center][font_size=15]Goal:\nNow wait for it to finish cooking and pick it up when it's done."

const process_gui = "[center][font_size=15]Goal:\nPress the movement buttons in the direction the blue arrows are facing to finish processing"

const mix_dish = "[center][font_size=15]Goal:\nNow you have all the ingredients together, so finish the dish by mixing it! (Q/U)"
const stove_dish = "[center][font_size=15]Goal:\nNow you have all the ingredients together, so finish the dish by cooking it on the stove!"
const oven_dish = "[center][font_size=15]Goal:\nNow you have all the ingredients together, so finish the dish by cooking it in the oven!"

const get_order = "[center][font_size=15]Goal:\nStart by using the order counter to take the next customer's order. (E/O)"
const order_complete = "[center][font_size=15]Goal:\nThe order is complete! Now you can bring it to the customer pickup station."
const finish_order = "[center][font_size=15]Goal:\nUse Q/U to ring the bell and let the customer know to grab their food!"
const complete_quota = "[center][font_size=15]Goal:\nNow keep making this dish until you fill the bar at the top"
const overtime = "[center][font_size=15]Goal:\nNow that you completed the bar, you have until it empties again to max out your score before unlocking a new dish!"

const tutorial_complete = "[center][font_size=15]Goal:\nThats the end of the tutorial, you can keep practicing or go to the main menu and play the real game!"

@onready var main: Main = get_node("/root/Main")
@onready var label: RichTextLabel = $PanelContainer/PanelContainer/VBoxContainer/RichTextLabel
@onready var sprite: AnimatedSprite2D = $PanelContainer/PanelContainer/VBoxContainer/Panel/Control/AnimatedSprite2D

var desired_parameter = ""


func action(awaited_signal: Signal, new_desired_parameter=""):
	awaited_signal.connect(process_signal)
	desired_parameter = new_desired_parameter
	
	await action_complete
	
	awaited_signal.disconnect(process_signal)


func process_signal(parameter:=""):
	print(parameter)
	if parameter.begins_with(desired_parameter):
		action_complete.emit()


func update_goal(new_text := "", new_spriteframes: SpriteFrames = null, new_frame: int = 0):
	label.text = new_text
	sprite.sprite_frames = new_spriteframes
	sprite.frame = new_frame


func start_tutorial():
	visible = true
	
	await pizza_tutorial()
	
	update_goal(
		get_order,
		load("res://Art/Spriteframes/OrderCounter.tres")
	)
	
	await main.order_taken
	
	await fried_chicken_tutorial()
	
	update_goal(
		complete_quota,
		load("res://Art/SpriteFrames/FriedChicken.tres")
	)
	
	await main.quota_reached
	
	update_goal(
		overtime,
		load("res://Art/SpriteFrames/FriedChicken.tres")
	)
	
	await main.overtime_end
	
	update_goal(
		get_order,
		load("res://Art/Spriteframes/OrderCounter.tres")
	)
	
	await main.order_taken
	
	await salad_tutorial()
	
	update_goal(tutorial_complete)


func fried_chicken_tutorial():
	update_goal(
		grab_plate,
		load("res://Art/Spriteframes/PlateStation.tres")
	)
	
	await action(main.item_interact, "grab_Plate")
	
	update_goal(
		place_plate,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_interact, "place_Plate")
	
	update_goal(
		grab_chicken,
		load("res://Art/Spriteframes/ChickenStation.tres")
	)
	
	await action(main.item_interact, "grab_Chicken")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_Chicken_plate")
	
	update_goal(
		grab_flour,
		load("res://Art/Spriteframes/FlourStation.tres")
	)
	
	await action(main.item_interact, "grab_Flour")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_Flour_plate")
	
	update_goal(
		stove_dish,
		load("res://Art/Spriteframes/Stove.tres")
	)
	
	await action(main.item_interact, "place_Plate_Stove")
	
	update_goal(
		wait_for_cook,
		load("res://Art/Spriteframes/Stove.tres"),
		1
	)
	
	await action(main.item_interact, "grab_FriedChicken")
	
	update_goal(
		order_complete,
		load("res://Art/Spriteframes/PickupCounter.tres")
	)
	
	await action(main.item_interact, "place_FriedChicken_DepositStation")
	
	update_goal(
		finish_order,
		load("res://Art/Spriteframes/PickupCounter.tres")
	)
	
	await action(main.item_process, "FriedChicken_DepositStation")


func salad_tutorial():
	update_goal(
		grab_plate,
		load("res://Art/Spriteframes/PlateStation.tres")
	)
	
	await action(main.item_interact, "grab_Plate")
	
	update_goal(
		place_plate,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_interact, "place_Plate")
	
	update_goal(
		grab_lettuce,
		load("res://Art/Spriteframes/LettuceStation.tres")
	)
	
	await action(main.item_interact, "grab_Lettuce")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_Lettuce_plate")
	
	update_goal(
		grab_chicken,
		load("res://Art/Spriteframes/ChickenStation.tres")
	)
	
	await action(main.item_interact, "grab_Chicken")
	
	update_goal(
		oven_ingredient,
		load("res://Art/Spriteframes/Oven.tres")
	)
	
	await action(main.item_interact, "place_Chicken_Oven")
	
	update_goal(
		wait_for_cook,
		load("res://Art/Spriteframes/Oven.tres"),
		2
	)
	
	await action(main.item_interact, "grab_CookedChicken")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_CookedChicken_plate")
	
	update_goal(
		mix_dish,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_process, "Plate")
	
	update_goal(
		process_gui,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_processed, "ChickenSalad")
	
	update_goal(
		order_complete,
		load("res://Art/Spriteframes/PickupCounter.tres")
	)
	
	await action(main.item_interact, "place_ChickenSalad_DepositStation")
	
	update_goal(
		finish_order,
		load("res://Art/Spriteframes/PickupCounter.tres")
	)
	
	await action(main.item_process, "ChickenSalad_DepositStation")


func pizza_tutorial():
	update_goal(
		grab_plate,
		load("res://Art/Spriteframes/PlateStation.tres")
	)
	
	await action(main.item_interact, "grab_Plate")
	
	update_goal(
		place_plate,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_interact, "place_Plate")
	
	update_goal(
		grab_flour,
		load("res://Art/Spriteframes/FlourStation.tres")
	)
	
	await action(main.item_interact, "grab_Flour")
	
	update_goal(
		place_counter_mix,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_interact, "place_Flour_Counter")
	
	update_goal(
		mix_ingredient,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_process, "Flour")
	
	update_goal(
		process_gui,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_processed, "Dough")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_Dough_plate")
	
	update_goal(
		grab_tomato,
		load("res://Art/Spriteframes/TomatoStation.tres")
	)
	
	await action(main.item_interact, "grab_Tomato")
	
	update_goal(
		place_counter_mix,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_interact, "place_Tomato_Counter")
	
	update_goal(
		mix_ingredient,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_process, "Tomato")
	
	update_goal(
		process_gui,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_processed, "TomatoPaste")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_TomatoPaste_plate")
	
	update_goal(
		grab_cheese,
		load("res://Art/Spriteframes/CheeseStation.tres")
	)
	
	await action(main.item_interact, "grab_Cheese")
	
	update_goal(
		place_cutting_station,
		load("res://Art/Spriteframes/CuttingStation.tres")
	)
	
	await action(main.item_interact, "place_Cheese_CuttingStation")
	
	update_goal(
		cut_ingredient,
		load("res://Art/Spriteframes/CuttingStation.tres")
	)
	
	await action(main.item_process, "Cheese")
	
	update_goal(
		process_gui,
		load("res://Art/Spriteframes/Counter.tres")
	)
	
	await action(main.item_processed, "GratedCheese")
	
	update_goal(
		place_on_plate,
		load("res://Art/Spriteframes/Plate.tres")
	)
	
	await action(main.item_interact, "place_GratedCheese_plate")
	
	update_goal(
		oven_dish,
		load("res://Art/Spriteframes/Oven.tres")
	)
	
	await action(main.item_interact, "place_Plate_Oven")
	
	update_goal(
		wait_for_cook,
		load("res://Art/Spriteframes/Oven.tres"),
		1
	)
	
	await action(main.item_interact, "grab_Pizza")
	
	update_goal(
		order_complete,
		load("res://Art/Spriteframes/PickupCounter.tres")
	)
	
	await action(main.item_interact, "place_Pizza_DepositStation")
	
	update_goal(
		finish_order,
		load("res://Art/Spriteframes/PickupCounter.tres")
	)
	
	await action(main.item_process, "Pizza_DepositStation")
