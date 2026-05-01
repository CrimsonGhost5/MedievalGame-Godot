extends Interactable

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var end_credits = preload("res://Levels/end_credits.tscn") as PackedScene


func _on_interacted(body: Variant) -> void:
	
	animation_player.play("end_door_open")
	
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(end_credits)
