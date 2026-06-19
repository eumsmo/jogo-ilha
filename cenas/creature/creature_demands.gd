extends Node

@export var demands: Array[Demand]
var _demand_idx: int = -1
var current_demand: Demand = null

@export var photo_demand: Demand


signal on_new_demand(demand: Demand)
signal on_demand_realized(demand: Demand)

signal need_to_reveal_photos
signal _returned_from_photos

signal need_to_fade
signal _has_faded_in
signal _has_faded_out

func _ready() -> void:
	await get_tree().process_frame
	go_to_next_demand()

func can_realize(victim: TheVictim) -> bool:
	return (current_demand.can_realize(victim.inventory) if current_demand != null else false) or victim.camera.is_full()

func try_to_realize(victim: TheVictim) -> void:
	var demand = current_demand
	
	if victim.camera.is_full() and current_demand != photo_demand:
		show_photos(victim)
		return
	
	if current_demand != null and current_demand.realize(victim.inventory):
		if demand.fade_to_black or not demand.activate_node_with_name.is_empty():
			need_to_fade.emit()
			await _has_faded_in
		
		on_demand_realized.emit(current_demand)
		go_to_next_demand()
		
		if demand.fade_to_black or not demand.activate_node_with_name.is_empty():
			if not demand.activate_node_with_name.is_empty():
				activate_node(demand.activate_node_with_name)
			await _has_faded_out
		
		if demand == photo_demand:
			await show_photos(victim)



func go_to_next_demand() -> void:
	_demand_idx += 1
	if _demand_idx >= 0 and _demand_idx < len(demands):
		current_demand = demands[_demand_idx]
	else:
		current_demand = null
	
	on_new_demand.emit(current_demand)

func show_photos(victim: TheVictim) -> void:
	victim.lock()
	need_to_reveal_photos.emit()
	await _returned_from_photos
	victim.unlock()

func viewed_photos() -> void:
	_returned_from_photos.emit()

func faded_in() -> void:
	_has_faded_in.emit()

func faded_out() -> void:
	_has_faded_out.emit()

func activate_node(name: String) -> void:
	var node = get_node_by_name(name)
	if node != null:
		node.show()
		node.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		print("Failed in finding " + name + " node.")

func get_node_by_name(name: String) -> Node3D:
	if name.is_empty():
		return null
	
	var nodes = get_tree().get_nodes_in_group("appear_on_demand")
	for node in nodes:
		if node.name == name:
			return node
	
	return null
