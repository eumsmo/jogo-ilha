class_name SimpleInteractable
extends Interactable

signal on_interact(victim: TheVictim)
@export var delete_node: Node


func interact(victim: TheVictim) -> void:
	on_interact.emit(victim)
	victim.hands.clear_closest_interactable()
	
	if delete_node != null:
		delete_node.queue_free()
		_is_deleting = true
