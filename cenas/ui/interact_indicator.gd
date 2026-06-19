extends Control

@export var indicator: Label
@export var hand_text: String = "[E] para interagir"
@export var camera_text: String = "[E] para tirar fotos"
@export var fishing_text: String = "[E] para pescar"

func _ready() -> void:
	Game.instance.victim.hands.closest_interactable_changed.connect(update_indicator)
	Game.instance.victim.fishing_rod.fishing_status_changed.connect(set_indicator_visibility)
	Game.instance.victim.on_hand_tool_changed.connect(on_hand_tool_changed)
	on_hand_tool_changed(Game.instance.victim.on_hand)
	indicator.hide()

func on_hand_tool_changed(hand_tool: HandTool) -> void:
	match hand_tool:
		Game.instance.victim.hands:
			indicator.text = hand_text
			hide_indicator()
		Game.instance.victim.camera:
			indicator.text = camera_text
			show_indicator()
		Game.instance.victim.fishing_rod:
			indicator.text = fishing_text
			hide_indicator()

func update_indicator(interactable: Interactable) -> void:
	if interactable == null:
		indicator.hide()
		return
	
	indicator.show()

func show_indicator() -> void:
	indicator.show()

func hide_indicator() -> void:
	indicator.hide()

func set_indicator_visibility(is_visible: bool) -> void:
	indicator.visible = is_visible
