class_name DemandUIItem
extends Control

@export var text: Label
@export var done: Control
var realized = false

func set_text(text: String) -> void:
	self.text.text = text

func set_realized() -> void:
	if realized:
		return
	
	realized = true
	done.show()
