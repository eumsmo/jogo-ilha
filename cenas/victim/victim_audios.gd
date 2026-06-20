class_name VictimAudio
extends Node3D

enum FloorType { NOTHING, WOOD, SAND, GRASS, ROCK }

@export var player: AudioStreamPlayer
@export var walk_player: AudioStreamPlayer
var walking: bool = false

@export var start_offset: Dictionary[AudioStream, float]

var floor_type: FloorType


@export_group("Streams")
@export var camera_click: AudioStream
@export var fishing_road_catch: AudioStream
@export var axe_cut: AudioStream
@export var hand_collect: AudioStream
@export var walk_wood: AudioStream
@export var walk_grass: AudioStream
@export var walk_sand: AudioStream
@export var walk_rock: AudioStream
var walk: AudioStream

var walk_dict: Dictionary = {
	FloorType.WOOD: func(): return walk_wood,
	FloorType.SAND: func(): return walk_sand,
	FloorType.GRASS: func(): return walk_grass,
	FloorType.ROCK: func(): return walk_rock,
	FloorType.NOTHING: func(): return null,
}


func play(stream: AudioStream) -> void:
	var offset = 0.0 if not start_offset.has(stream) else start_offset[stream]
	player.stream = stream
	player.play(offset)

func stop() -> void:
	player.stop()

func set_floor_type(type: FloorType) -> void:
	if floor_type == type:
		return
	
	floor_type = type
	walk = walk_dict[type].call()
	
	if walking:
		walk_player.stream = walk
		walk_player.play()

func get_floor_type(node: Node3D) -> FloorType:
	if node == null:
		return FloorType.NOTHING
	if node.is_in_group("wood_floor"):
		return FloorType.WOOD
	if node.is_in_group("sand_floor"):
		return FloorType.SAND
	if node.is_in_group("grass_floor"):
		return FloorType.GRASS
	if node.is_in_group("rock_floor"):
		return FloorType.ROCK
	return FloorType.NOTHING


func start_walking() -> void:
	if walking:
		return
	
	walking = true
	walk_player.stream = walk
	walk_player.play()

func stop_walking() -> void:
	if not walking:
		return
	
	walking = false
	walk_player.stop()
