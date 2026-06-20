class_name Game
extends Node3D

static var instance: Game

@export var victim: TheVictim
@export var creature: TheCreature
@export var ritual: Ritual
@export var center: Node3D

var player_interact_lock: bool = false
signal on_bad_ending

func _init() -> void:
	instance = self
	
func _ready() -> void:
	ritual.on_end.connect(bad_ending)
	
func bad_ending() -> void:
	on_bad_ending.emit()
	victim.lock()
	await get_tree().create_timer(3)
	get_tree().change_scene_to_file("res://ending.tscn")
