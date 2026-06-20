extends MarginContainer

@export var progress: TextureProgressBar

func _ready() -> void:
	Game.instance.creature.poison_time_updated.connect(update_progress)

func update_progress(normalized_val: float) -> void:
	progress.value = normalized_val
	
	if normalized_val == 0 or normalized_val == 1:
		hide()
	else:
		show()
