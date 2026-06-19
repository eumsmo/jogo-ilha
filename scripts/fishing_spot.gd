class_name FishingSpot
extends StaticBody3D

signal on_caught

var was_caught: bool = false
@export var destroy_node_on_caught: Node3D

@export var item: Item

func caught() -> void:
	if was_caught:
		return
	
	was_caught = true
	
	Game.instance.victim.inventory.add_item(item)
	on_caught.emit()
	
	if destroy_node_on_caught != null:
		destroy_node_on_caught.queue_free()

func reset() -> void:
	was_caught = false
