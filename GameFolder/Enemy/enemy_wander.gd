extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0
var target: Node3D

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

func _ready() -> void:
	target = PlayerManager.player

#The Enemy will randomly choose a spot to go to and walk towards the spot
func randomize_variables():
	wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	wander_time = randf_range(1.5, 10)

#Enters in the random variable
func enter():
	randomize_variables()

func process(_delta: float):
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= _delta
	
	#If the player gets too close to the enemy then the ememy switches state
	if enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyChase")

func physics_process(_delta: float):
	#Allows the enemy to move
	enemy.velocity = wander_direction * enemy.WalkSpeed
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
