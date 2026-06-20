extends Interactable

@export var requirements: Array[ItemQuantity]
@export var delete_node: Node3D
@export var show_node: Node3D

@export var fade_time: float = 0

func can_interact(victim: TheVictim) -> bool:
	return super(victim) and has_requirements(victim)

func interact(victim: TheVictim) -> void:
	for item_quantity in requirements:
		victim.inventory.sub_item(item_quantity.item, item_quantity.quant)
		
	victim.hands.clear_closest_interactable()
	
	if fade_time > 0:
		await Game.instance.fade_in()
		
	
	if show_node != null:
		show_node.show()
		show_node.process_mode = Node.PROCESS_MODE_INHERIT
	
	if fade_time > 0:
		await get_tree().create_timer(fade_time).timeout
		
	if delete_node != null:
		delete_node.queue_free()
		_is_deleting = true
	
	if fade_time > 0:
		Game.instance.fade_out()
	
	

func has_requirements(victim: TheVictim) -> bool:
	for item_quantity in requirements:
		if not victim.inventory.has_quant(item_quantity.item, item_quantity.quant):
			return false

	
	return true
