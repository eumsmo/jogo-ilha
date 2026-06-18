extends Node

@export var demands: Array[Demand]
var _demand_idx: int = -1
var current_demand: Demand = null

@export var photo_demand: Demand


signal on_new_demand(demand: Demand)
signal on_demand_realized(demand: Demand)

signal need_to_reveal_photos
signal _returned_from_photos

func _ready() -> void:
	await get_tree().process_frame
	go_to_next_demand()

func can_realize(victim: TheVictim) -> bool:
	return (current_demand.can_realize(victim.inventory) if current_demand != null else false) or victim.camera.is_full()

func try_to_realize(victim: TheVictim) -> void:
	print(victim.camera.is_full(), current_demand)
	if victim.camera.is_full() and current_demand != photo_demand:
		victim.lock()
		need_to_reveal_photos.emit()
		await _returned_from_photos
		victim.unlock()
		return
	
	if current_demand != null and current_demand.realize(victim.inventory):
		on_demand_realized.emit(current_demand)
		go_to_next_demand()

func go_to_next_demand() -> void:
	_demand_idx += 1
	if _demand_idx >= 0 and _demand_idx < len(demands):
		current_demand = demands[_demand_idx]
	else:
		current_demand = null
	
	on_new_demand.emit(current_demand)

func viewed_photos() -> void:
	_returned_from_photos.emit()
