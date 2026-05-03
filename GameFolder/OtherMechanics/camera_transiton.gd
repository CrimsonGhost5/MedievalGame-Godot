extends Node

@onready var camera3D: Camera3D = $Camera3D

var transitioning: bool = false

func _ready() -> void:
	camera3D.current = false
	

func switch_camera(from, to) -> void:
	from.current = false
	to.current = true

func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	camera3D.fov = from.fov
	camera3D.cull_mask = from.cull_mask
	
	# Move our transition camera to the first camera position
	camera3D.global_transform = from.global_transform
	
	# Make our transition camera current
	camera3D.current = true
	
	transitioning = true
	
	# Make the second camera current
	to.current = true
	transitioning = false
