extends HandTool

var victim: TheVictim

@export var shape_cast: ShapeCast3D
var tree: FruitTree
var last_status: bool = false

signal can_cut_status_changed(found: bool)
signal started_cutting
signal ended_cutting

func _ready() -> void:
	victim = Game.instance.victim

func on_unequip(_victim: TheVictim) -> void:
	tree = null
	
	if last_status:
		last_status = false
		can_cut_status_changed.emit(last_status)

func use_tool(_victim: TheVictim) -> void:
	tree = get_closest_collision()
	
	if tree != null:
		victim.lock()
		victim.audio.play(victim.audio.axe_cut)
		
		started_cutting.emit()
		await get_tree().create_timer(1).timeout
		tree.cut()
		await victim.audio.player.finished
		ended_cutting.emit()
		victim.unlock()
		await get_tree().create_timer(1).timeout

func _physics_process(delta: float) -> void:
	if victim.on_hand != self or victim.locked:
		return
	
	_handle_trees(delta)

func _handle_trees(_delta: float) -> void:
	tree = get_closest_collision()
	
	var status = tree != null
	
	if status != last_status:
		can_cut_status_changed.emit(status)
	
	last_status = status

func get_closest_collision() -> FruitTree:
	if not shape_cast.is_colliding():
		return null
	
	var closest = null
	var closest_dist = INF
	
	for i in range(0, shape_cast.get_collision_count()):
		var collider = shape_cast.get_collider(i)
		if collider is not FruitTree or not collider.can_be_cut or collider.was_cut:
			continue
		
		var collision_point = shape_cast.get_collision_point(i)
		var dist = collision_point.distance_to(shape_cast.position)
		if dist < closest_dist:
			closest = collider
			closest_dist = dist
	
	return closest
