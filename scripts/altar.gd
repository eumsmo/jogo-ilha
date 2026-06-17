extends Interactable

func interact(victim: TheVictim) -> void:
	if Game.instance.creature.demands.can_realize(victim):
		Game.instance.creature.demands.try_to_realize(victim)
