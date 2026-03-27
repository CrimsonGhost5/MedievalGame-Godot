extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0
var target: Node3D

@onready var enemy: CharacterBody3D = get_parent().get_parent()

@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

@onready var close_audio = $"../../Audio/Close"

@onready var random_pos = Vector3(randf_range(-5.0, 5.0), enemy.position.y, randf_range(-5.0, 5.0))

@export var new_spot_timer = 1.0

func _ready() -> void:
	target = PlayerManager.player

#The Enemy will randomly choose a spot to go to and walk towards the spot
func randomize_variables():
	#nav_agent.target_position = random_pos
	#if (abs(random_pos.x - enemy.global_position.x) <= 5 and abs(random_pos.z - enemy.global_position.z) <= 5) or wander_time <= 0:
		#random_pos = Vector3(randf_range(target.global_position.x - 10, target.global_position.x + 10), enemy.position.y, randf_range(target.global_position.z - 10, target.global_position.z + 10))
		#clamp(random_pos.x, -5.0, 5.0)
		#clamp(random_pos.y, -5.0, 5.0)
		#wander_time = 60
	
	wander_direction.x = randf_range(-2.0, 2.0)
	wander_direction.z = randf_range(-2.0, 2.0)
	nav_agent.set_target_position(wander_direction)
	wander_time = randf_range(1.5, 3)
	

#Enters in the random variable
func enter():
	randomize_variables()
	enemy.spot_timer = new_spot_timer

func process(_delta: float):
	#enemy.look_at(enemy.global_transform.origin + enemy.velocity)
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= _delta
	
	#If the player gets too close to the enemy then the ememy switches state
	if enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemySpot")
	
	if enemy.global_position.distance_to(target.global_position) < enemy.CloseDistance:
		close_audio.play()

func physics_process(_delta: float):
	#Allows the enemy to move
	enemy.velocity = wander_direction * enemy.WalkSpeed
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
