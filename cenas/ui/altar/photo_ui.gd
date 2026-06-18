extends Control

@export_range(0, 360, 0.1, "radians_as_degrees") var rot_angle_max: float

@export_group("References")
@export var photo: TextureRect
@export var animator: AnimationPlayer

func _ready() -> void:
	set_rand_rotation()

func set_photo(img: Texture2D) -> void:
	photo.texture = img
	set_rand_rotation()

func set_rand_rotation() -> void:
	randomize()
	var rand_rot = randf_range(-rot_angle_max, rot_angle_max)
	rotation = rand_rot

func enter() -> void:
	animator.play("enter")

func leave() -> void:
	animator.play("exit")

func comeback() -> void:
	animator.play("comeback")
