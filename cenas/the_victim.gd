class_name TheVictim
extends CharacterBody3D


const SPEED = 7.5

@export var center: Node3D
@export var own_body: Node3D


@export var inventory: Inventory

var on_hand: HandTool
@export var tools_holder: Node3D

@export var camera: HandTool
@export var fishing_rod: HandTool
@export var hands: HandTool


# Interactable
@export var shape_cast: ShapeCast3D
var closest_interactable: Interactable = null
signal closest_interactable_changed(interactable: Interactable)


signal using_action
signal on_hand_tool_changed(tool: HandTool)

func _ready() -> void:
	switch_hand_tool()

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_interactables(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		on_hand.use_tool(self)
	
	if event.is_action_pressed("switch"):
		switch_hand_tool()
	
	if event.is_action_pressed("interact") and closest_interactable != null and closest_interactable.can_interact(self):
		closest_interactable.interact(self)

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

func clear_closest_interactable() -> void:
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

func set_hand_tool(tool: HandTool) -> void:
	if tool != null and not tool.available:
		return
	
	if on_hand != null and on_hand != tool:
		on_hand.hide()
	
	if tool != null:
		on_hand = tool
		on_hand.show()
		on_hand_tool_changed.emit(on_hand)
	else:
		on_hand_tool_changed.emit(null)

func switch_hand_tool() -> void:
	if on_hand == null:
		set_hand_tool(tools_holder.get_child(0))
		return
	
	var idx = on_hand.get_index()
	
	while true:
		idx = (idx+1) % tools_holder.get_child_count()
		var tool = tools_holder.get_child(idx)
		
		if tool.available or tool == on_hand:
			break
	
	set_hand_tool(tools_holder.get_child(idx))
	
