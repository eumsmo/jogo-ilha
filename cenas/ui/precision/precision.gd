class_name Precision
extends Control

@export var time: float

@export var min_scale: float = 0.01
@export var max_scale: float = 2.5

@export_range(0.0,0.5,0.01) var ok_range: float = 0.05
@export_range(0.0,1.0,0.05) var hit_on: float = 0.5
@export_range(-0.05,1.0,0.05) var time_missed_on: float = -1


@export_group("Fade Times")
@export var fade_in_time: float = 0.3
@export var fade_out_time: float = 0.3



var value_func: Callable

var last_value: float = -1
var timer: float = -1


@export_group("References")
@export var circle: Control
@export var right_place: Control

signal on_hitted
signal on_missed
signal on_changed(hit: bool)

var hitted: bool = false
var missed: bool = false

var _fading_in: bool = false
var _fading_out: bool = false

func _ready() -> void:
	circle.hide()
	right_place.scale = _get_scale_at(hit_on)

## Value func receives (normalized_time, previous_value) and should return normalized_value, where 0.5 is the moment to press. Notice: first previous value is -1
func set_value_func(value: Callable) -> void:
	value_func = value

func set_time(time: float) -> void:
	self.time = time

func start() -> void:
	timer = time
	circle.show()
	circle.scale = _get_scale_at(value_func.call(1, -1))

func _physics_process(delta: float) -> void:
	if timer <= 0:
		return
	
	timer = clamp(timer-delta, 0, time)
	
	var normalized_timer = timer/time
	var val = value_func.call(normalized_timer, last_value)
	
	circle.scale = _get_scale_at(val)
	last_value = val
	
	if timer == 0:
		on_miss()
	
	if not missed and timer < time_missed_on:
		missed = true
		fade_out()


func _get_scale_at(val: float) -> Vector2:
	return Vector2.ONE * lerpf(min_scale, max_scale, val)


func check() -> bool:
	return abs(hit_on - last_value) <= ok_range

func on_hit() -> void:
	timer = 0
	
	hitted = true
	missed = false
	
	on_hitted.emit()
	on_changed.emit(true)

func on_miss() -> void:
	hitted = false
	missed = true
	
	on_missed.emit()
	on_changed.emit(false)
	fade_out()

func set_opacity(opacity: float) -> void:
	var color = modulate
	color.a = opacity
	modulate = color

func fade_in() -> void:
	if _fading_in:
		return
	
	_fading_in = true
	set_opacity(0.0)
	var target = modulate
	target.a = 1
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", target, fade_in_time)
	await get_tree().create_timer(fade_in_time)
	_fading_in = false

func fade_out() -> void:
	if _fading_out:
		return
	
	_fading_out = true
	
	set_opacity(1.0)
	var target = modulate
	target.a = 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", target, fade_out_time)
	await get_tree().create_timer(fade_out_time)
	_fading_out = true
	
