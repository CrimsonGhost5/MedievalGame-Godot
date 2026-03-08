extends Area3D

const DialogueSystemPreload = preload("res://Dialogue/dialogue.tscn")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var override_diaiogie_position: bool
@export var override_position: Vector3
@export var dialogue: Array[DE]
var player_body_in: bool = false
var has_activated_already: bool = false
var desired_dialogue_pos: Vector3

var player_node: Node3D

func _ready() -> void:
	player_node = PlayerManager.player
	for i in get_tree().get_nodes_in_group("Player"):
		player_node = i

func _process(_delta: float) -> void:
	if !player_node:
		for i in get_tree().get_nodes_in_group("Player"):
			player_node = i
		return
	
	if !activate_instant and player_body_in:
		if only_activate_once and has_activated_already:
			set_process(false)
			return
		
		if Input.is_action_just_pressed("interact"):
			_activate_dialogue()
			player_body_in = false

func _activate_dialogue() -> void:
	player_node.moving =  false
	
	var new_dialogue = DialogueSystemPreload.instantiate()
	if override_diaiogie_position:
		desired_dialogue_pos = override_position
	new_dialogue.global_position = desired_dialogue_pos
	new_dialogue.dialogue = dialogue
	get_parent().add_child(new_dialogue)
	

func _on_body_entered(body: Node3D) -> void:
	if only_activate_once and has_activated_already:
		return
	if body.is_in_group("Player"):
		player_body_in = true
		if activate_instant:
			_activate_dialogue()



func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_body_in = false
