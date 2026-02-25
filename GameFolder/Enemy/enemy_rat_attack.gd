extends State
class_name EnemyRatAttack

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

var target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = PlayerManager.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float):
	if enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyRatRunAway")
		

func physics_process(_delta: float):
	var target_origin = target.get_global_transform().origin
	
	var target_position = target.position
	
	var enemy_origin = enemy.position.normalized()
	
	var offset = target_position + enemy_origin
	
	enemy.velocity = enemy.global_position.direction_to(offset) * enemy.WalkSpeed
