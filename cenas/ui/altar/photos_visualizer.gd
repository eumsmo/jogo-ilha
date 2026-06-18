extends Control

@export var time_between_photos: float = 0.3
@export var time_last_entered_photo: float = 0.75

@export var photo_scene: PackedScene
@export var photos_holder: Control
@export var texture_temp: Texture2D
@export var photo_item: Item

var photos: Array[Control]
var finished_entering := false

func _ready() -> void:
	Game.instance.creature.demands.need_to_reveal_photos.connect(show_photos)
	hide()

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		if finished_entering:
			go_to_next()


func show_photos() -> void:
	finished_entering = false
	
	var textures: Array[Texture2D] = get_photos()
	textures.reverse()
	show()
	
	for texture in textures:
		create_photo_ui(texture)
		await get_tree().create_timer(time_between_photos).timeout
	
	await get_tree().create_timer(time_last_entered_photo).timeout
	
	finished_entering = true

func get_photos() -> Array[Texture2D]:
	var imgs: Array = Game.instance.victim.camera.photos
	var textures: Array[Texture2D]
	
	for img in imgs:
		var texture = ImageTexture.create_from_image(img)
		textures.append(texture)
	
	return textures

func create_photo_ui(texture: Texture2D) -> void:
	var photo_ui = photo_scene.instantiate()
	photo_ui.hide()
	photo_ui.set_photo(texture)
	
	photos_holder.add_child(photo_ui)
	photo_ui.enter()
	await get_tree().process_frame
	photo_ui.show()
	
	photos.append(photo_ui)

func close() -> void:
	hide()
	Game.instance.victim.camera.clear()
	Game.instance.creature.demands.viewed_photos()

func go_to_next() -> void:
	if len(photos) == 0:
		return
	
	var last = photos.back()
	photos.erase(last)
	last.leave()
	Game.instance.victim.inventory.sub_item(photo_item)
	
	if len(photos) == 0:
		await last.animator.animation_finished
		close()
