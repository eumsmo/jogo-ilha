class_name Game
extends Node3D

static var instance: Game

@export var victim: TheVictim
@export var interact_indicator: Node3D

func _init() -> void:
	instance = self

func _ready() -> void:
	victim.closest_interactable_changed.connect(put_indicator_at)
	interact_indicator.reparent(self)
	interact_indicator.owner = self

func put_indicator_at(interactable: Interactable):
	if interactable == null:
		hide_indicator()
		return
	
	interact_indicator.global_position = interactable.indicator_holder.global_position
	interact_indicator.show()

func hide_indicator():
	interact_indicator.global_position = Vector3.ZERO
	interact_indicator.hide()
