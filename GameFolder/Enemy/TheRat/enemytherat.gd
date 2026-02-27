extends CharacterBody3D

var wander_direction: Vector3
var wander_time: float = 0.0
var target: Node3D

@export var WalkSpeed: float = 1.0
@export var RunSpeed: float = 5.0
@export var AttackRange: float = 1.5
@export var ChaseDistance: float = 10.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = PlayerManager.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if wander_time < 0.0:
		#wander()
	
	wander_time -= delta

func _physics_process(delta: float) -> void:
	#wander()
	move_and_slide()

#func wander() -> void:
	#look_at(global_transform.origin + velocity)
	#
	#wander_direction.x = randf_range(-2.0, 2.0)
	#wander_direction.z = randf_range(-2.0, 2.0)
	#nav_agent.set_target_position(wander_direction)
	#wander_time = randf_range(1.5, 3)

func runaway() -> void:
	pass
