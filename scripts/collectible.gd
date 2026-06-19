class_name Collectible
extends Interactable

@export var item: Item

@export_group("References")
@export var delete_node: Node


func can_interact(victim: TheVictim) -> bool:
	return super(victim) and not victim.inventory.is_item_full(item)

func collect(victim: TheVictim) -> void:
	interact(victim)

func interact(victim: TheVictim) -> void:
	victim.inventory.add_item(item)
	victim.hands.clear_closest_interactable()
	delete_node.queue_free()
	_is_deleting = true
