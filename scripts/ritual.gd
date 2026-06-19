class_name Ritual
extends Node3D

signal player_entered
signal player_left

signal on_end

var player_in: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "TheVictim":
		player_in = true
		player_entered.emit()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "TheVictim":
		player_in = false
		player_left.emit()

func _input(event: InputEvent) -> void:
	if not player_in:
		return
		
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		on_end.emit()
