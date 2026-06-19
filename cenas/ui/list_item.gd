class_name DemandUIItem
extends Control

@export var text: RichTextLabel
var realized = false

func set_text(text: String) -> void:
	self.text.text = text

func set_realized() -> void:
	if realized:
		return
	
	realized = true
	text.text = "[s]" + text.text + "[/s]"
