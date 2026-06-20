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
@export var axe: HandTool
@export var hands: HandTool

@export var animator: AnimationPlayer
@export var audio: VictimAudio
@export var raycast_floor: RayCast3D



enum VictimAnimations { IDLE, WALK, CAM_IDLE, CAM_WALK, FISH_IDLE, FISH_WALK }
@export var animations: Dictionary[VictimAnimations, String]


var locked := false

var deslocamento: float = 0.0
var last_position: Vector3

signal using_action
signal on_hand_tool_changed(tool: HandTool)

func _ready() -> void:
	last_position = global_position
	switch_hand_tool()

func _physics_process(delta: float) -> void:
	if locked:
		return
	
	_handle_movement(delta)
	_handle_floor()
	#_handle_interactables(delta)

func _input(event: InputEvent) -> void:
	if locked:
		return
		
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		if not Game.instance.player_interact_lock:
			on_hand.use_tool(self)
	
	if event.is_action_pressed("switch"):
		switch_hand_tool()
	

func _handle_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var base = center.global_transform.basis
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (base * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	
	
	deslocamento = global_position.distance_to(last_position)
	last_position = global_position
	
	if direction:
		look_at(global_position - direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	set_animation(direction)

	move_and_slide()

func set_hand_tool(tool: HandTool) -> void:
	if tool != null and not tool.available:
		return
	
	if on_hand != null and on_hand != tool:
		on_hand.hide()
		on_hand.on_unequip(self)
	
	if tool != null:
		on_hand = tool
		on_hand.show()
		on_hand_tool_changed.emit(on_hand)
		on_hand.on_equip(self)
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


func set_animation(direction: Vector3) -> void:
	if deslocamento > 0.0:
		audio.start_walking()
		match on_hand:
			camera:
				animator.play(animations[VictimAnimations.CAM_WALK])
			fishing_rod:
				animator.play(animations[VictimAnimations.FISH_WALK])
			axe:
				animator.play(animations[VictimAnimations.FISH_WALK])
			_:
				animator.play(animations[VictimAnimations.WALK])
	else:
		audio.stop_walking()
		match on_hand:
			camera:
				animator.play(animations[VictimAnimations.CAM_IDLE])
			fishing_rod:
				animator.play(animations[VictimAnimations.FISH_IDLE])
			axe:
				animator.play(animations[VictimAnimations.FISH_IDLE])
			_:
				animator.play(animations[VictimAnimations.IDLE])

func lock() -> void:
	locked = true

func unlock() -> void:
	locked = false

func change_center(center: Node3D) -> void:
	self.center = center



func _handle_floor() -> void:
	var col: CollisionObject3D = raycast_floor.get_collider()
	audio.set_floor_type(audio.get_floor_type(col))
