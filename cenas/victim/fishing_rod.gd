extends HandTool

var victim: TheVictim

@export var shape_cast: ShapeCast3D
var fishing_spot: FishingSpot
var last_status: bool = false

signal fishing_status_changed(found: bool)

func _ready() -> void:
	victim = Game.instance.victim

func on_unequip(_victim: TheVictim) -> void:
	fishing_spot = null
	
	if last_status:
		last_status = false
		fishing_status_changed.emit(last_status)

func use_tool(_victim: TheVictim) -> void:
	fishing_spot = get_closest_collision()
	
	if fishing_spot != null:
		victim.audio.play(victim.audio.fishing_road_catch)
		fishing_spot.caught()

func _physics_process(delta: float) -> void:
	if victim.on_hand != self or victim.locked:
		return
	
	_handle_fishs(delta)

func _handle_fishs(_delta: float) -> void:
	fishing_spot = get_closest_collision()
	
	var status = fishing_spot != null
	
	if status != last_status:
		fishing_status_changed.emit(status)
	
	last_status = status

func get_closest_collision() -> FishingSpot:
	if not shape_cast.is_colliding():
		return null
	
	var closest = null
	var closest_dist = INF
	
	for i in range(0, shape_cast.get_collision_count()):
		var collider = shape_cast.get_collider(i)
		if collider is not FishingSpot or collider.was_caught:
			continue
		
		var collision_point = shape_cast.get_collision_point(i)
		var dist = collision_point.distance_to(shape_cast.position)
		if dist < closest_dist:
			closest = collider
			closest_dist = dist
	
	return closest
