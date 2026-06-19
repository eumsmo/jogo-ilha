class_name PrecisionController
extends Control

enum ActivateBy { TIME, HITTING_PREVIOUS }

@export var order: Array[OneHitPrecision]
@export var activate_next_by: ActivateBy
## Time that takes to start the next precision check (only works on activate_next_by == ActivateBy.TIME)
@export var time_between_precisions: float

var running: bool = false
var currently_playing: Array[OneHitPrecision]

func _ready() -> void:
	#play()
	pass

func _input(event: InputEvent) -> void:
	if not running:
		return
		
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		on_check()

func play() -> void:
	show()
	
	currently_playing.clear()
	
	var hitted_all = true # Only makes sense when activate_next_by == ActivateBy.HITTING_PREVIOUS
	var last_precision = null
	
	for pre in order:
		pre.set_opacity(0)
	
	var order_not_hitted = order.filter(func(pre: OneHitPrecision): return not pre.hitted)
	
	if len(order_not_hitted) > 0:
		await order_not_hitted[0].fade_in()
	
	running = true
	
	for i in range(0, len(order_not_hitted)):
		var precision = order_not_hitted[i]
		if i < len(order_not_hitted) - 1:
			order_not_hitted[i+1].fade_in()
		
		last_precision = precision
		precision.start()
		currently_playing.append(precision)
		
		if activate_next_by == ActivateBy.TIME:
			await get_tree().create_timer(time_between_precisions).timeout
		elif activate_next_by == ActivateBy.HITTING_PREVIOUS:
			var hitted = await precision.on_changed
			if not hitted:
				hitted_all = false
				break
	
	if activate_next_by == ActivateBy.TIME and last_precision != null:
		await last_precision.on_changed
	
	running = false
	
	hide()

func on_check() -> void:
	var current = get_first_not_missed()
	if current == null:
		return
	
	if current.check():
		current.on_hit()
	else:
		current.on_miss()
		

func get_first_not_missed() -> OneHitPrecision:
	for pre in currently_playing:
		if not pre.missed and not pre.hitted:
			return pre
	return null
