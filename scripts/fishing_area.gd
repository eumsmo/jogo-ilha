extends Node3D

@export var fishing_holder: Node3D
@export var bubbles: Node3D
@export var bubbles_fishing: FishingSpot
@export var bubbles_particles: GPUParticles3D

@export var time_for_next_min: float = 2.0
@export var time_for_next_max: float = 5.0

var last_spot: Node3D = null

func _ready() -> void:
	set_new_spot(get_rand_spot())

func on_caught() -> void:
	bubbles_particles.emitting = false
	await get_tree().create_timer(time_for_next_min).timeout
	
	bubbles.hide()
	bubbles.process_mode = Node.PROCESS_MODE_DISABLED
	
	var time = randf_range(time_for_next_min, time_for_next_max)
	await get_tree().create_timer(time).timeout
	set_new_spot(get_rand_spot())

func get_rand_spot() -> Node3D:
	var spot = last_spot
	
	if fishing_holder.get_child_count() == 1:
		return fishing_holder.get_child(0)
	
	while spot == last_spot:
		var idx = randi_range(0, fishing_holder.get_child_count()-1)
		spot = fishing_holder.get_child(idx)
	
	return spot

func set_new_spot(spot: Node3D) -> void:
	last_spot = spot
	
	if bubbles.get_parent() != spot:
		bubbles.reparent(spot)
		bubbles.position = Vector3.ZERO
	
	bubbles_fishing.reset()
	bubbles.show()
	bubbles.process_mode = Node.PROCESS_MODE_INHERIT
	bubbles_particles.emitting = true
