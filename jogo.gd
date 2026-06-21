class_name Game
extends Node3D

static var instance: Game

@export var victim: TheVictim
@export var creature: TheCreature
@export var ritual: Ritual
@export var cave: Cave
@export var center: Node3D
@export var cave_music: AudioStreamPlayer

var player_interact_lock: bool = false
signal on_bad_ending
signal on_good_ending

signal on_fade_in
signal on_fade_in_ended
signal on_fade_out
signal on_fade_out_ended

func _init() -> void:
	instance = self
	
func _ready() -> void:
	stop_cave()
	ritual.on_end.connect(bad_ending)
	
func bad_ending() -> void:
	on_bad_ending.emit()
	victim.lock()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://bad_ending.tscn")


func good_ending() -> void:
	on_good_ending.emit()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://good_ending.tscn")

func fade_in() -> void:
	on_fade_in.emit()
	await on_fade_in_ended

func fade_out() -> void:
	on_fade_out.emit()
	await on_fade_out_ended

func handle_fade_in_ended() -> void:
	on_fade_in_ended.emit()

func handle_fade_out_ended() -> void:
	on_fade_out_ended.emit()

func pause_music() -> void:
	Music.instance.pause()

func unpause_music() -> void:
	Music.instance.unpause()
	
func stop_music() -> void:
	Music.instance.stop()

func start_music() -> void:
	Music.instance.start()

func start_cave() -> void:
	cave_music.stream_paused = false

func stop_cave() -> void:
	cave_music.stream_paused = true
