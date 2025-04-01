extends CanvasLayer


signal action_complete

const grab_plate = "[center][font_size=15]Goal:\nEvery dish starts with a plate, grab one from the plate supplier! (E/O)"
const grab_lettuce = "[center][font_size=15]Goal:\nNext we need to grab a piece of lettuce from the lettuce supplier."
const grab_chicken = "[center][font_size=15]Goal:\nNext we need to grab a piece of chicken from the chicken supplier."
const grab_flour = "[center][font_size=15]Goal:\nNext we need to grab a piece of flour from the flour supplier."
const grab_tomato = "[center][font_size=15]Goal:\nNext we need to grab a piece of tomato from the tomato supplier."
const grab_cheese = "[center][font_size=15]Goal:\nNext we need to grab a piece of cheese from the cheese supplier."

const place_plate = "[center][font_size=15]Goal:\nNow place this plate on a counter so you can add the ingredients. (E/O)"
const place_on_plate = "[center][font_size=15]Goal:\nNext add this ingredient to the plate. (E/O)"

const stove_ingredient = "[center][font_size=15]Goal:\nThis ingredient needs to be cooked on the stove for this recipe."
const oven_ingredient = "[center][font_size=15]Goal:\nThis ingredient needs to be cooked in the oven for this recipe."
const wait_for_cook = "[center][font_size=15]Goal:\nNow wait for it to finish cooking and pick it up when it's done."

const mix_dish = "[center][font_size=15]Goal:\nNow you have all the ingredients together, so finish the dish by mixing it! (Q/U)"
const stove_dish = "[center][font_size=15]Goal:\nNow you have all the ingredients together, so finish the dish by cooking it on the stove!"
const oven_dish = "[center][font_size=15]Goal:\nNow you have all the ingredients together, so finish the dish by cooking it in the oven!"

const get_order = "[center][font_size=15]Goal:\nStart by using the order counter to take the next customer's order. (E/O)"
const order_complete = "[center][font_size=15]Goal:\nThe order is complete! Now you can bring it to the customer pickup station."
const finish_order = "[center][font_size=15]Goal:\nUse Q/U to ring the bell and let the customer know to grab their food!"

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


func start_tutorial():
	visible = true
	
	label.text = get_order
	sprite.sprite_frames = load("res://Art/Spriteframes/OrderCounter.tres")
	
	await main.order_taken
	
	await salad_tutorial()
	
	label.text = get_order
	sprite.sprite_frames = load("res://Art/Spriteframes/OrderCounter.tres")
	
	await main.order_taken
	
	await fried_chicken_tutorial()
	
	label.text = tutorial_complete
	sprite.sprite_frames = null


func salad_tutorial():
	label.text = grab_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/PlateStation.tres")
	
	await action(main.item_interact, "grab_Plate")
	
	label.text = place_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/Counter.tres")
	
	await action(main.item_interact, "place_Plate")
	
	label.text = grab_lettuce
	sprite.sprite_frames = load("res://Art/Spriteframes/LettuceStation.tres")
	
	await action(main.item_interact, "grab_Lettuce")
	
	label.text = place_on_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/Plate.tres")
	
	await action(main.item_interact, "place_Lettuce_plate")
	
	label.text = grab_chicken
	sprite.sprite_frames = load("res://Art/Spriteframes/ChickenStation.tres")
	
	await action(main.item_interact, "grab_Chicken")
	
	label.text = oven_ingredient
	sprite.sprite_frames = load("res://Art/Spriteframes/Oven.tres")
	
	await action(main.item_interact, "place_Chicken_Oven")
	
	label.text = wait_for_cook
	sprite.frame = 2
	
	await action(main.item_interact, "grab_CookedChicken")
	
	label.text = place_on_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/Plate.tres")
	
	await action(main.item_interact, "place_CookedChicken_plate")
	
	label.text = mix_dish
	sprite.sprite_frames = load("res://Art/Spriteframes/Plate.tres")
	
	await action(main.item_processed, "ChickenSalad")
	
	label.text = order_complete
	sprite.sprite_frames = load("res://Art/Spriteframes/PickupCounter.tres")
	
	await action(main.item_interact, "place_ChickenSalad_DepositStation")
	
	label.text = finish_order
	
	await action(main.item_process, "ChickenSalad_DepositStation")


func fried_chicken_tutorial():
	label.text = grab_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/PlateStation.tres")
	
	await action(main.item_interact, "grab_Plate")
	
	label.text = place_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/Counter.tres")
	
	await action(main.item_interact, "place_Plate")
	
	label.text = grab_chicken
	sprite.sprite_frames = load("res://Art/Spriteframes/ChickenStation.tres")
	
	await action(main.item_interact, "grab_Chicken")
	
	label.text = place_on_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/Plate.tres")
	
	await action(main.item_interact, "place_Chicken_plate")
	
	label.text = grab_flour
	sprite.sprite_frames = load("res://Art/Spriteframes/FlourStation.tres")
	
	await action(main.item_interact, "grab_Flour")
	
	label.text = place_on_plate
	sprite.sprite_frames = load("res://Art/Spriteframes/Plate.tres")
	
	await action(main.item_interact, "place_Flour_plate")
	
	label.text = stove_dish
	sprite.sprite_frames = load("res://Art/Spriteframes/Stove.tres")
	
	await action(main.item_interact, "place_Plate_Stove")
	
	label.text = wait_for_cook
	sprite.sprite_frames = load("res://Art/Spriteframes/Stove.tres")
	sprite.frame = 2
	
	await action(main.item_interact, "grab_FriedChicken")
	
	label.text = order_complete
	sprite.sprite_frames = load("res://Art/Spriteframes/PickupCounter.tres")
	
	await action(main.item_interact, "place_FriedChicken_DepositStation")
	
	label.text = finish_order
	
	await action(main.item_process, "FriedChicken_DepositStation")
