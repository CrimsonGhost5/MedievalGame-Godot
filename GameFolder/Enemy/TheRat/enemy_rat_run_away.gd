extends State
class_name EnemyRatRunAway

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

var target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = PlayerManager.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy.global_position.distance_to(target.global_position) > enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyRatWander")
	if enemy.global_position.distance_to(target.global_position) < enemy.AttackRange && enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyRatAttack")
		

func physics_process(_delta: float) -> void:
	var target_origin = target.get_global_transform().origin
	
	var target_position = target.position
	
	var direction: Vector3 = enemy.position.direction_to(target_position)
	
	var enemy_origin = enemy.position.normalized()
	
	var offset = target_position + enemy_origin
	
	enemy.velocity = -enemy.global_position.direction_to(offset) * enemy.RunSpeed
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
