extends Node3D

@export var speed: float = 1.0
@export var close_margin: float = 0.001

@export_group("Referencias")
@export var porta: Node3D
@export var porta_up: Node3D
@export var porta_down: Node3D

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
	
	if not is_on_target():
		old_position = porta.global_position
		timer = 0.0
		moving = true
	
func fechar_porta() -> void:
	target = porta_up.global_position
	
	if not is_on_target():
		old_position = porta.global_position
		timer = 0.0
		moving = true
