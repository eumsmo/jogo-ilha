class_name TheCreature
extends Node3D

@export var eye: CreatureEye
@export var camera: Camera3D
@export var eye_rotation: Node3D
@export var demands: CreatureDemands
@export var altar_point: Node3D

@export_group("Poison Values")
@export var poison_time: float = 60.0
@export var poison_after_still_for: float = 10.0

var poisoned: bool = false
var poison_timer: float = 0.0
var poison_coef: float = 1.0

var victim_still: float = 0.0

signal poison_time_updated(normalized_time: float)
signal was_poisoned
signal was_unpoisoned

func _physics_process(delta: float) -> void:
	if not poisoned:
		return
	
	poison_timer += delta * poison_coef
	
	var normalized_time = clampf(poison_timer/poison_time, 0, 1)
	poison_time_updated.emit(normalized_time)
	
	if Game.instance.victim.deslocamento == 0:
		victim_still += delta
		if victim_still >= poison_after_still_for:
			poison_coef = 2*victim_still/poison_after_still_for
	else:
		victim_still = 0.0
		poison_coef = 1.0
	
	if normalized_time == 1:
		unpoison()

func poison() -> void:
	poison_timer = 0.0
	poisoned = true
	eye.poison()
	Game.instance.stop_music()
	
	was_poisoned.emit()
	

func unpoison() -> void:
	poisoned = false
	
	await Game.instance.fade_in()
	Game.instance.cave.tp_off_cave(Game.instance.victim)
	Game.instance.victim.global_position = altar_point.global_position
	await get_tree().create_timer(0.5).timeout
	eye.unpoison()
	was_unpoisoned.emit()
	await Game.instance.fade_out()
	
	
	
