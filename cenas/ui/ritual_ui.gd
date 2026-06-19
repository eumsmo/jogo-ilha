extends Label

@export var indicator: Control

func _ready() -> void:
	var ritual = Game.instance.ritual
	ritual.player_entered.connect(entered)
	ritual.player_left.connect(left)
	left()

func entered() -> void:
	indicator.hide()
	show()
	Game.instance.player_interact_lock = true

func left() -> void:
	indicator.show()
	hide()
	Game.instance.player_interact_lock = false
	
