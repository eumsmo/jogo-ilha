class_name Inventory
extends Node

var inventory: Dictionary[Item, int]

signal on_item_change(item: Item, quant: int)
signal on_action_made(action: String, item: Item, quant: int)


func set_item(item: Item, quant: int) -> void:
	if quant == 0 and inventory.has(item):
		inventory.erase(item)
		on_item_change.emit(item, 0)
	else:
		inventory.set(item, quant)
		on_item_change.emit(item, quant)

func get_item(item: Item, quant: int) -> int:
	return inventory.get(item) if inventory.has(item) else 0

func has_item(item: Item) -> bool:
	return inventory.has(item)

func has_quant(item: Item, quant: int) -> bool:
	return false if not inventory.has(item) else (inventory.get(item) >= quant)

func add_item(item: Item, quant: int = 1) -> void:
	if quant < 0:
		return sub_item(item, -quant)
		
	if quant == 0:
		return
	
	if not inventory.has(item):
		inventory.set(item, quant)
		on_item_change.emit(item, quant)
		return
	
	var value = inventory.get(item)
	value += quant
	inventory.set(item, value)
	on_item_change.emit(item, value)

func sub_item(item: Item, quant: int = 1) -> void:
	if quant < 0:
		return add_item(item, -quant)
		
	if quant == 0 or not inventory.has(item):
		return
	
	var value = inventory.get(item)
	if quant >= value:
		inventory.erase(item)
		on_item_change.emit(item, 0)
		return
	
	value = value - quant
	inventory.set(item, value)
	on_item_change.emit(item, value)
