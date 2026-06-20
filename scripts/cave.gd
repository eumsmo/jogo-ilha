class_name Cave
extends Node3D

@export var speed: float = 1.0
@export var close_margin: float = 0.001

@export var sound_range_close: float = 5
@export var sound_range_open: float = 10


@export_group("Referencias")
@export var porta: Node3D
@export var porta_up: Node3D
@export var porta_down: Node3D

@export var spawn_outside: Node3D
@export var spawn_inside: Node3D

@export var interact_enter: StaticBody3D
@export var audio_stream: AudioStreamPlayer3D


var old_position: Vector3
var target: Vector3
var moving: bool = false
var timer: float = 0.0



func _ready() -> void:
	target = porta.global_position

func _physics_process(delta: float) -> void:
	if not moving:
		return
		
	porta.global_position = lerp(porta.global_position, target, speed * delta)
	
	if is_on_target():
		porta.global_position = target
		timer = 0.0
		moving = false
	

func is_on_target() -> bool:
	return porta.global_position.distance_to(target) < close_margin

func abrir_porta() -> void:
	target = porta_down.global_position
	
	interact_enter.process_mode = Node.PROCESS_MODE_INHERIT
	audio_stream.max_distance = sound_range_open
	
	if not is_on_target():
		old_position = porta.global_position
		timer = 0.0
		moving = true
	
func fechar_porta() -> void:
	target = porta_up.global_position
	
	interact_enter.process_mode = Node.PROCESS_MODE_DISABLED
	audio_stream.max_distance = sound_range_close
	
	if not is_on_target():
		old_position = porta.global_position
		timer = 0.0
		moving = true


func enter_cave(victim: TheVictim) -> void:
	victim.change_center(Game.instance.center)
	victim.global_position = spawn_inside.global_position
	Game.instance.start_cave()
	Game.instance.pause_music()


func exit_cave(victim: TheVictim) -> void:
	victim.change_center(Game.instance.creature.eye_rotation)
	victim.global_position = spawn_outside.global_position
	Game.instance.stop_cave()
	Game.instance.unpause_music()

func tp_off_cave(victim: TheVictim) -> void:
	victim.change_center(Game.instance.creature.eye_rotation)
	Game.instance.stop_cave()
	Game.instance.unpause_music()


func _on_enter_cave_on_interact(victim: TheVictim) -> void:
	enter_cave(victim)


func _on_cave_to_outside_on_interact(victim: TheVictim) -> void:
	exit_cave(victim)
