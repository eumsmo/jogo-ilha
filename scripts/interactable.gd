class_name Interactable
extends StaticBody3D

@export var indicator_holder: Node3D

func can_interact(_victim: TheVictim) -> bool:
	return true

func interact() -> void:
	pass
