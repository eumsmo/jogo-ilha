extends Control

@export var demand_item_scene: PackedScene
@export var demands_holder: Control

var current_demand: Demand = null
var demands: Dictionary[Demand, DemandUIItem]

func _ready() -> void:
	var creature = Game.instance.creature
	creature.demands.on_new_demand.connect(handle_new_demand)
	creature.demands.on_demand_realized.connect(handle_demand_realized)

func handle_new_demand(demand: Demand) -> void:
	if demand == current_demand:
		return
	
	if current_demand != null:
		demands[current_demand].set_realized()
			
	if demand != null:
		var demand_item: DemandUIItem = demand_item_scene.instantiate()
		demand_item.set_text(demand.text)
		demands_holder.add_child(demand_item)
		demands[demand] = demand_item


func handle_demand_realized(demand: Demand) -> void:
	if demands.has(demand):
		demands[demand].set_realized()
