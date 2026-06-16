class_name Interactable
extends StaticBody3D

var _is_deleting: bool = false
@export var indicator_holder: Node3D

func can_interact(_victim: TheVictim) -> bool:
	return not _is_deleting

func interact(_victim: TheVictim) -> void:
	pass
