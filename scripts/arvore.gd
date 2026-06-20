class_name FruitTree
extends Interactable

@export var item: Item
@export var cut_item: Item
@export var fruit_scene: PackedScene
@export var places_holder: Node3D
@export var timer_next: Timer
var spawned_fruit: Node3D

@export var can_spawn_more: bool = false
@export var can_be_cut: bool = false
var was_cut: bool = false

@export var root: Node3D

func _ready() -> void:
	randomize()
	create_apple()

func can_interact(victim: TheVictim) -> bool:
	return super(victim) and spawned_fruit != null

func interact(victim: TheVictim) -> void:
	if spawned_fruit == null:
		return
	
	victim.inventory.add_item(item)
	victim.hands.clear_closest_interactable()
	spawned_fruit.queue_free()
	spawned_fruit = null
	
	if can_spawn_more:
		timer_next.start()

func create_apple() -> void:
	if spawned_fruit != null:
		return
	
	var holder = get_random_spot()
	var fruit = fruit_scene.instantiate()
	holder.add_child(fruit)
	
	spawned_fruit = fruit

func get_random_spot() -> Node3D:
	var idx = randi_range(0, places_holder.get_child_count()-1)
	return places_holder.get_child(idx)

func cut() -> void:
	if not can_be_cut or was_cut:
		return
	
	was_cut = true
	Game.instance.victim.inventory.add_item(cut_item)
	
	if spawned_fruit != null:
		Game.instance.victim.inventory.add_item(item)
	
	root.queue_free()
	_is_deleting = true
