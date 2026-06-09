class_name Game
extends Node3D

static var instance: Game

@export var victim: TheVictim
@export var interact_indicator: Node3D

func _init() -> void:
	instance = self

func _ready() -> void:
	victim.closest_interactable_changed.connect(put_indicator_at)

func put_indicator_at(interactable: Interactable):
	if interactable == null:
		hide_indicator()
		return
	
	interact_indicator.reparent(interactable.indicator_holder)
	interact_indicator.position = Vector3.ZERO
	interact_indicator.show()

func hide_indicator():
	if interact_indicator.get_parent() != self:
		interact_indicator.reparent(self)
		interact_indicator.position = Vector3.ZERO
	interact_indicator.hide()
