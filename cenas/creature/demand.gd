class_name Demand
extends Resource

@export_multiline var text: String
@export var items: Array[ItemQuantity]

func can_realize(inventory: Inventory) -> bool:
	for item_quantity in items:
		if not inventory.has_quant(item_quantity.item, item_quantity.quant):
			return false
	
	return true

func realize(inventory: Inventory) -> bool:
	if not can_realize(inventory):
		return false
	
	for item_quantity in items:
		inventory.sub_item(item_quantity.item, item_quantity.quant)
	
	return true
