class_name CreatureEye
extends Node3D

@export var cam: Camera3D
@export var eye_rot: Node3D
@export var victim: Node3D
@export var creature: Node3D

@export_group("Get closer")
@export var top_ref: Node3D
@export var bottom_ref: Node3D
@export var start_closing_dist: float = 23.0
@export var closest_dist: float = 13.0

var shake_strength: float = 5.0
var shake_fade: float = 5.0
var current_shake: float = 0.0

func _physics_process(delta: float) -> void:
	eye_rot.look_at(victim.position)
	
	var weight = 0.0
	var dist = victim.position.distance_to(creature.position)
	
	if dist < closest_dist:
		weight = 1.0
	elif dist < start_closing_dist:
		var completion_steps = start_closing_dist-closest_dist
		var current_steps = start_closing_dist-dist
		weight = current_steps/completion_steps
	
	position = lerp(top_ref.position, bottom_ref.position, clamp(weight, 0.0, 1.0))
	
	if current_shake > 0.0:
		current_shake = lerpf(current_shake, 0, shake_fade * delta)
		cam.h_offset = randf_range(-current_shake, current_shake)
		cam.v_offset = randf_range(-current_shake, current_shake)

func poison() -> void:
	shake()
	cam.reparent(Game.instance)

func unpoison() -> void:
	cam.reparent(eye_rot)
	Game.instance.start_music()
	cam.position = Vector3.ZERO
	cam.rotation = Vector3.ZERO

func shake() -> void:
	current_shake = shake_strength
