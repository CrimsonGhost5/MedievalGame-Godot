extends Node3D

signal level_changed(level_name)

@export var level_name = "level"

func _ready() -> void:
	if PlayerManager.player.position != Vector3(0, 0, 0):
		PlayerManager.player.position = PlayerManager.position + Vector3(0, 0, 0)

func _on_next_level_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		PlayerManager.position = $Player.position
