class_name VictimAudio
extends Node3D

@export var player: AudioStreamPlayer

@export var start_offset: Dictionary[AudioStream, float]

@export_group("Streams")
@export var camera_click: AudioStream
@export var fishing_road_catch: AudioStream
@export var hand_collect: AudioStream


func play(stream: AudioStream) -> void:
	var offset = 0.0 if not start_offset.has(stream) else start_offset[stream]
	player.stream = stream
	player.play(offset)

func stop() -> void:
	player.stop()
