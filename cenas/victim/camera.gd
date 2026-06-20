extends HandTool

@export var photos_per_camera: int = 4
@export var photo_item: Item

@export var auto_aim_cast: RayCast3D
@export var aim_node: Node3D
var place_to_aim: Node3D = null

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

func _physics_process(delta: float) -> void:
	try_to_aim()

func try_to_aim() -> void:
	place_to_aim = auto_aim_cast.get_collider()
	if place_to_aim == null:
		aim_node.rotation = Vector3.ZERO
	else:
		aim_node.look_at(place_to_aim.global_position)

func take_picture() -> Image:
	camera.current = true
	
	var rot = camera_viewpoint.global_rotation if place_to_aim == null else aim_node.global_rotation
	camera.global_position = camera_viewpoint.global_position
	camera.global_rotation = rot
	
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
