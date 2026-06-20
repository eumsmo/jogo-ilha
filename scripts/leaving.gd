extends Node3D

@export var stand_in: Marker3D
@export var animator: AnimationPlayer
@export var animation_name: String

var leaving: bool = false

func enter_on_boat() -> void:
	var victim = Game.instance.victim
	
	#victim.reparent(stand_in)
	victim.global_position = stand_in.global_position
	
	victim.lock()
	
	leaving = true
	
	await get_tree().create_timer(1.0).timeout
	play_leave()
	await get_tree().create_timer(10.0).timeout
	Game.instance.good_ending()

func _physics_process(delta: float) -> void:
	if not leaving:
		return
	
	Game.instance.victim.global_position = stand_in.global_position
	Game.instance.victim.global_rotation = stand_in.global_rotation
	

func play_leave() -> void:
	animator.play(animation_name)


func _on_simple_interactable_on_interact(victim: TheVictim) -> void:
	enter_on_boat()
