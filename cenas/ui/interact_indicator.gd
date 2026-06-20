extends Control

@export var indicator: Label
@export var start_text: String = "[E] para "
@export var hand_text: String = "interagir"
@export var camera_text: String = "tirar fotos"
@export var fishing_text: String = "pescar"
@export var axe_text: String = "cortar"
var text: String

func _ready() -> void:
	Game.instance.victim.hands.closest_interactable_changed.connect(update_indicator)
	Game.instance.victim.fishing_rod.fishing_status_changed.connect(set_indicator_visibility)
	Game.instance.victim.axe.can_cut_status_changed.connect(set_indicator_visibility)
	Game.instance.victim.on_hand_tool_changed.connect(on_hand_tool_changed)
	on_hand_tool_changed(Game.instance.victim.on_hand)
	indicator.hide()

func on_hand_tool_changed(hand_tool: HandTool) -> void:
	match hand_tool:
		Game.instance.victim.hands:
			text = hand_text
			hide_indicator()
		Game.instance.victim.camera:
			text = camera_text
			show_indicator()
		Game.instance.victim.fishing_rod:
			text = fishing_text
			hide_indicator()
		Game.instance.victim.axe:
			text = axe_text
			hide_indicator()
	
	indicator.text = start_text + text

func update_indicator(interactable: Interactable) -> void:
	if interactable == null:
		indicator.hide()
		return
	
	if not interactable.custom_interact_text.is_empty():
		indicator.text = start_text + interactable.custom_interact_text
	else:
		indicator.text = start_text + text
	
	indicator.show()

func show_indicator() -> void:
	indicator.show()

func hide_indicator() -> void:
	indicator.hide()

func set_indicator_visibility(is_visible: bool) -> void:
	indicator.visible = is_visible
