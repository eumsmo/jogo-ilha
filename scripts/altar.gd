extends Interactable

func can_interact(victim: TheVictim) -> bool:
	return super(victim) and (Game.instance.creature.demands.can_realize(victim) or victim.camera.is_full())

func interact(victim: TheVictim) -> void:
	if Game.instance.creature.demands.can_realize(victim):
		Game.instance.creature.demands.try_to_realize(victim)
