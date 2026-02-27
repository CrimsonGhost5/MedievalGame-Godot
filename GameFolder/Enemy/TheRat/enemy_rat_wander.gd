extends State
class_name EnemyRatWander

var wander_time: float = 0.0
var target: Node3D

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

@onready var random_pos = Vector3(randf_range(-2.0, 2.0), enemy.position.y, randf_range(-5.0, 5.0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = PlayerManager.player




func randomize_variables():
	enemy.wander_direction.x = randf_range(-2.0, 2.0)
	enemy.wander_direction.z = randf_range(-2.0, 2.0)
	nav_agent.set_target_position(enemy.wander_direction)
	wander_time = randf_range(1.5, 3)

func enter():
	randomize_variables()

func process(_delta: float):
	enemy.look_at(enemy.global_transform.origin + enemy.velocity)
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= _delta
	
	if enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyRatRunAway")
	

func physics_process(_delta: float):
	#Allows the enemy to move
	enemy.velocity = enemy.wander_direction * enemy.WalkSpeed
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
