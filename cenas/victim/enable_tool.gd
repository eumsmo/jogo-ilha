extends Interactable

enum Tools { HAND, CAMERA, FISHING, AXE }

@export var delete_node: Node3D
@export var which: Tools

func _ready() -> void:
	custom_interact_text = "get the " + get_tool_name(which)

func interact(victim: TheVictim) -> void:
	var tool = null
	match which:
		Tools.HAND:
			tool = victim.hands
		Tools.CAMERA:
			tool = victim.camera
		Tools.FISHING:
			tool = victim.fishing_rod
		Tools.AXE:
			tool = victim.axe
	
	tool.available = true
	victim.set_hand_tool(tool)
	
	victim.hands.clear_closest_interactable()
	delete_node.queue_free()
	_is_deleting = true

func get_tool_name(tool: Tools) -> String:
	match which:
		Tools.HAND:
			return "hand"
		Tools.CAMERA:
			return "camera"
		Tools.FISHING:
			return "fishing rod"
		Tools.AXE:
			return "axe"
	return "thing"
