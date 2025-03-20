extends Interactable


@onready var main: Main = get_tree().get_root().get_node("Main")


func interact(_player: Player):
	if not main.new_customers:
		return
	
	var customer: Customer = main.new_customers[0]
	
	main.new_customers.remove_at(0)
	main.waiting_customers.append(customer)
	customer.lineUp(Vector2(-50, 120), main.waiting_customers)
