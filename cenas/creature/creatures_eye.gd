extends Node

@export var cam: Camera3D
@export var victim: Node3D

func _physics_process(delta: float) -> void:
	cam.look_at(victim.position)
