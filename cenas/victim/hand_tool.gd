class_name HandTool
extends Node

@export var available: bool
@export var img: CompressedTexture2D

func use_tool(_victim: TheVictim) -> void:
	pass

func on_equip(_victim: TheVictim) -> void:
	pass

func on_unequip(_victim: TheVictim) -> void:
	pass
