class_name InventoryUISlot
extends HBoxContainer

@export var image: TextureRect
@export var text: Label

var item: Item
var quant: int

func set_item(item: Item, quant: int = 0) -> void:
	self.item = item
	self.quant = quant
	update_visual()

func update_visual() -> void:
	image.texture = item.img
	
	if item.max_quant > 0:
		text.text = "{0}/{1}".format([quant, item.max_quant])
	else:
		text.text = str(quant)
