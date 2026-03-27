extends State
class_name EnemySpot


var wander_direction: Vector3

var target: Node3D

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"


func enter():
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = PlayerManager.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta: float) -> void:
	if enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		enemy.spot_timer -= 1 * _delta
	
	if enemy.spot_timer < 0 and enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyChase")
	
	if enemy.global_position.distance_to(target.global_position) > enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyWander")
	
	


func physics_process(_delta: float):
	enemy.velocity = wander_direction * enemy.WalkSpeed * 0 
