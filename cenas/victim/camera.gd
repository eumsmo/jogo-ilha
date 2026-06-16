extends HandTool

@export var camera: Camera3D
@export var camera_viewpoint: Node3D
var viewport: Viewport

func _ready() -> void:
	viewport = camera.get_viewport()
	viewport.world_3d = get_viewport().world_3d
	camera.current = false

func use_tool() -> void:
	take_picture()

func take_picture() -> void:
	camera.current = true
	camera.global_position = camera_viewpoint.global_position
	camera.global_rotation = camera_viewpoint.global_rotation
	
	await RenderingServer.frame_post_draw
	var img: Image = viewport.get_texture().get_image()
	img.save_png("user://teste.png")
	camera.current = false
	print(img)
