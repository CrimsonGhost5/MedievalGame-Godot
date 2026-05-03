extends Node3D

@onready var camera1: Camera3D = $FreeCamera

@onready var camera2: Camera3D = $Player/Head/Camera3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if camera1.current:
			CameraTransiton.transition_camera3D(camera1, camera2, 1.5)
			GameState.set_value("cam control", false)
		else:
			CameraTransiton.transition_camera3D(camera2, camera1, 1.5)
			GameState.set_value("cam control", true)
