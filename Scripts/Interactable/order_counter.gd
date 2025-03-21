extends Interactable


@onready var main: Main = get_tree().get_root().get_node("Main")


func interact(_player: Player):
	if len(main.waiting_customers) >= 4:
		return
	
	var customer: Customer = main.new_customers[0]
	
	main.new_customers.remove_at(0)
	main.waiting_customers.append(customer)
	customer.lineUpHorizontal(Vector2(-100, 100), main.waiting_customers)
	
	if len(main.new_customers) >= 3:
		return
	
	main.spawn_customer()
