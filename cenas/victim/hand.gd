extends HandTool

var victim: TheVictim

@export var shape_cast: ShapeCast3D
var closest_interactable: Interactable = null
signal closest_interactable_changed(interactable: Interactable)

func _ready() -> void:
	victim = Game.instance.victim

func use_tool(_victim: TheVictim) -> void:
	if closest_interactable != null and closest_interactable.can_interact(victim):
		closest_interactable.interact(victim)

func on_unequip(_victim: TheVictim) -> void:
	clear_closest_interactable()

func _physics_process(delta: float) -> void:
	if victim.on_hand != self or victim.locked:
		return
	
	_handle_interactables(delta)

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
		if collider is not Interactable or not collider.can_interact(victim):
			continue
		
		var collision_point = shape_cast.get_collision_point(i)
		var dist = collision_point.distance_to(victim.position)
		if dist < closest_dist:
			closest = collider
			closest_dist = dist
	
	return closest
