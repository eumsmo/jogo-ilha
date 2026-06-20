extends Interactable

enum Tools { HAND, CAMERA, FISHING, AXE }

@export var delete_node: Node3D
@export var which: Tools

func interact(victim: TheVictim) -> void:
	match which:
		Tools.HAND:
			victim.hands.available = true
		Tools.CAMERA:
			victim.camera.available = true
		Tools.FISHING:
			victim.fishing_rod.available = true
		Tools.AXE:
			victim.axe.available = true
	
	victim.hands.clear_closest_interactable()
	delete_node.queue_free()
	_is_deleting = true
