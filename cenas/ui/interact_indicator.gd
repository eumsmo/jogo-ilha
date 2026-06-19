extends Control

@export var indicator: Control

func _ready() -> void:
	Game.instance.victim.closest_interactable_changed.connect(update_indicator)
	indicator.hide()

func update_indicator(interactable: Interactable) -> void:
	if interactable == null:
		indicator.hide()
		return
	
	indicator.show()
