extends State

@onready var player: CharacterBody3D = get_parent().get_parent()

func physics_process(_delta: float):
	if player.input_dir != Vector3.ZERO:
		emit_signal("Transitioned", self, "Move")
	player.move(5, 20, _delta)
	player.move_and_slide()
