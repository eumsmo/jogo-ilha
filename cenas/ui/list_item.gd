class_name DemandUIItem
extends Control

@export var text: RichTextLabel
var string_text: String
var realized = false

func set_text(text: String) -> void:
	string_text = text
	self.text.text = tr(string_text)

func set_realized() -> void:
	if realized:
		return
	
	realized = true
	text.text = "[s]" + tr(string_text) + "[/s]"
