class_name Interactable
extends StaticBody3D

## Press [E] to <your text here>
@export var custom_interact_text: String = ""
@export var play_sfx_on_interact: bool = true

var _is_deleting: bool = false

func can_interact(_victim: TheVictim) -> bool:
	return not _is_deleting

func interact(_victim: TheVictim) -> void:
	pass
