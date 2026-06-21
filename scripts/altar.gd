extends Interactable

func can_interact(victim: TheVictim) -> bool:
	custom_interact_text = ""
	if not super(victim):
		return false
	
	if Game.instance.creature.poisoned:
		return false
	
	if victim.camera.is_full():
		return true
	
	if victim.inventory.has_item(Game.instance.creature.demands.evil_fish):
		custom_interact_text = Game.instance.creature.demands.evil_fish_text
		return true
	
	
	return Game.instance.creature.demands.can_realize(victim)

func interact(victim: TheVictim) -> void:
	if Game.instance.creature.demands.can_realize(victim):
		Game.instance.creature.demands.try_to_realize(victim)
		victim.hands.clear_closest_interactable()
