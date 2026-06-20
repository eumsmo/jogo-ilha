extends Panel

@export var fade_in_time: float = 1.0
@export var between_fades_time: float = 1.0
@export var fade_out_time: float = 1.0

signal fade_in_finished
signal fade_out_finished

func _ready() -> void:
	hide()
	Game.instance.creature.demands.need_to_fade.connect(demand_fade)
	Game.instance.on_bad_ending.connect(fade_in)
	Game.instance.on_good_ending.connect(fade_in)
	Game.instance.victim.axe.started_cutting.connect(fade_in)
	Game.instance.victim.axe.ended_cutting.connect(fade_out)
	
	
	Game.instance.on_fade_in.connect(fade_in_by_game)
	Game.instance.on_fade_out.connect(fade_out_by_game)

func _fade(from: float, to: float, fade_time: float) -> void:
	var tween = get_tree().create_tween()
	var target = modulate
	target.a = to
	modulate.a = from
	
	tween.tween_property(self, "modulate", target, fade_time)
	await tween.finished

func fade_in() -> void:
	show()
	await _fade(0,1,fade_in_time)
	fade_in_finished.emit()

func fade_out() -> void:
	await _fade(1,0,fade_out_time)
	fade_out_finished.emit()
	hide()

func fade_in_out() -> void:
	await fade_in()
	await get_tree().create_timer(between_fades_time).timeout
	await fade_out()

func demand_fade() -> void:
	fade_in_finished.connect(Game.instance.creature.demands.faded_in)
	fade_out_finished.connect(Game.instance.creature.demands.faded_out)
	
	await fade_in_out()
	
	fade_in_finished.disconnect(Game.instance.creature.demands.faded_in)
	fade_out_finished.disconnect(Game.instance.creature.demands.faded_out)

func fade_in_by_game() -> void:
	await fade_in()
	Game.instance.handle_fade_in_ended()

func fade_out_by_game() -> void:
	await fade_out()
	Game.instance.handle_fade_out_ended()
