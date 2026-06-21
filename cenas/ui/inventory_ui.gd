extends Node

var slots: Dictionary[Item, InventoryUISlot]

@export_group("UI References")
@export var slot_scene: PackedScene
@export var slots_holder: Control
@export var on_hand: TextureRect
@export var how_to_switch_tip: Control

var first_switch: bool = true

func _ready() -> void:
	var victim = Game.instance.victim
	victim.inventory.on_item_change.connect(handle_inventory_change)
	victim.on_hand_tool_changed.connect(handle_hand_tool_changed)
	victim.manual_hand_change.connect(handle_switch_tip)

func handle_switch_tip() -> void:
	how_to_switch_tip.hide()

func handle_inventory_change(item: Item, quant: int) -> void:
	var slot = get_slot(item)
	if slot == null:
		if quant == 0:
			return
		
		slot = create_slot(item)
	elif quant == 0:
		slots.erase(item)
		slot.queue_free()
		return
	
	slot.set_item(item, quant)

func get_slot(item: Item) -> InventoryUISlot:
	return slots[item] if slots.has(item) else null

func create_slot(item: Item) -> InventoryUISlot:
	var slot: InventoryUISlot = slot_scene.instantiate()
	slot.set_item(item)
	slots[item] = slot
	slots_holder.add_child(slot)
	return slot


func handle_hand_tool_changed(tool: HandTool) -> void:
	if first_switch:
		first_switch = false
		how_to_switch_tip.show()
	
	if tool != null:
		on_hand.texture = tool.img
		on_hand.show()
	else:
		on_hand.hide()
