extends HandTool

@export var photos_per_camera: int = 4
@export var photo_item: Item


@export var camera: Camera3D
@export var camera_viewpoint: Node3D
var viewport: Viewport

var resize_by = 3.0

var photos: Array[Image]

func _ready() -> void:
	viewport = camera.get_viewport()
	viewport.world_3d = get_viewport().world_3d
	camera.current = false

func use_tool(victim: TheVictim) -> void:
	var count = len(photos)
	
	if count >= photos_per_camera:
		return
	
	victim.audio.play(victim.audio.camera_click)
	var img = await take_picture()
	
	img.save_png("user://img_{0}.png".format([count]))
	photos.append(img)
	victim.inventory.add_item(photo_item, 1)

func take_picture() -> Image:
	camera.current = true
	camera.global_position = camera_viewpoint.global_position
	camera.global_rotation = camera_viewpoint.global_rotation
	
	await RenderingServer.frame_post_draw
	var img: Image = viewport.get_texture().get_image()
	img.resize(img.get_width()/resize_by, img.get_height()/resize_by, Image.INTERPOLATE_NEAREST)
	img.resize(img.get_width()*resize_by, img.get_height()*resize_by, Image.INTERPOLATE_NEAREST)
	camera.current = false
	
	return img

func is_full() -> bool:
	return len(photos) >= photos_per_camera

func clear() -> void:
	photos.clear()
