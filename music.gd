class_name MainMusic
extends Node

var instance: MainMusic

@export var music: AudioStreamPlayer

func _init() -> void:
	instance = self

func _ready() -> void:
	start()

func pause() -> void:
	music.stream_paused = true

func unpause() -> void:
	music.stream_paused = false
	
func stop() -> void:
	music.stop()

func start() -> void:
	music.play()
