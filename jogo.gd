class_name Game
extends Node3D

static var instance: Game

@export var victim: TheVictim
@export var creature: TheCreature

func _init() -> void:
	instance = self
