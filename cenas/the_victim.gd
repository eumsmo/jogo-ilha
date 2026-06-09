class_name TheVictim
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var center: Node3D
@export var own_body: Node3D

# Interactable
@export var shape_cast: ShapeCast3D
var closest_interactable: Interactable = null
signal closest_interactable_changed(interactable: Interactable)


signal using_action


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_interactables(delta)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		using_action.emit()

func _handle_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var base = center.global_transform.basis
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (base * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	if direction:
		look_at(global_position - direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _handle_interactables(_delta: float) -> void:
	var col = get_closest_collision()
	if col != null:
		if col != closest_interactable:
			closest_interactable = col
			closest_interactable_changed.emit(closest_interactable)
	else:
		if closest_interactable != null:
			closest_interactable = null
			closest_interactable_changed.emit(closest_interactable)

func get_closest_collision() -> Interactable:
	if not shape_cast.is_colliding():
		return null
	
	var closest = null
	var closest_dist = INF
	
	for i in range(0, shape_cast.get_collision_count()):
		var collider = shape_cast.get_collider(i)
		if collider is not Interactable or not collider.can_interact(self):
			continue
		
		var collision_point = shape_cast.get_collision_point(i)
		var dist = collision_point.distance_to(position)
		if dist < closest_dist:
			closest = collider
			closest_dist = dist
	
	return closest
