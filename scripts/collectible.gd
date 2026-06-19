class_name Collectible
extends Interactable

@export var item: Item

@export_group("References")
@export var delete_node: Node

func collect(victim: TheVictim) -> void:
	interact(victim)

func interact(victim: TheVictim) -> void:
	victim.inventory.add_item(item)
	victim.clear_closest_interactable()
	delete_node.queue_free()
	_is_deleting = true
