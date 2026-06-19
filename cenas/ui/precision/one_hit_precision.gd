class_name OneHitPrecision
extends Precision

@export var play_on_ready: bool = false

@export var collect_on_hit: Collectible
var fading_out: bool = false

func _ready() -> void:
	super()
	
	set_value_func(simple_move)
	
	if play_on_ready:
		start()

func start() -> void:
	show()
	super()

func on_hit() -> void:
	super()
	
	hide()
	
	if collect_on_hit != null:
		collect_on_hit.collect(Game.instance.victim)

func reset() -> void:
	hitted = false

func simple_move(time: float, old: float) -> float:
	return time
