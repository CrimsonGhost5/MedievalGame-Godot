extends CharacterBody3D

@export var WalkSpeed: float = 1.0
@export var RunSpeed: float = 5.0
@export var AttackRange: float = 1.5
@export var ChaseDistance: float = 10.0
@export var CloseDistance: float = 15
@export var knockback_force: float
@export var spot_timer: float = 1.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_machine: StateMachine = $StateMachine
@onready var wander_state: State = $StateMachine/EnemyWander

# animation stuff
@onready var material = $Body.get_active_material(0)
@onready var standSprite = load("res://Enemy/TheHungry/HungryEnemy1.png")
@onready var walkSprite1 = load("res://Enemy/TheHungry/HungryEnemy2.png")
@onready var walkSprite2 = load("res://Enemy/TheHungry/HungryEnemy3.png")
@onready var stillSprite = load("res://Enemy/TheHungry/HungryEnemyStill.png")
var animating = false

var target: Node3D

func _ready() -> void:
	target = PlayerManager.player


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	# animate if velocity is moving
	if(self.velocity != Vector3(0, 0, 0) && animating == false):
		if(state_machine.current_state == wander_state):
			material.albedo_texture = stillSprite
		else:
			# animation
			animating = true
			animate(delta)
	# unanimate if standing still
	else: if(self.velocity == Vector3(0, 0, 0) && material.albedo_texture != standSprite || stillSprite):
		if(state_machine.current_state == wander_state):
			material.albedo_texture = stillSprite
		else:
			material.albedo_texture = standSprite


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == target:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 5.0, 0.12)
		$AnimationPlayer.play("pushback")

func animate(delta: float) -> void:
	material.albedo_texture = walkSprite1
	await get_tree().create_timer(30 * delta).timeout
	material.albedo_texture = walkSprite2
	await get_tree().create_timer(30 * delta).timeout
	animating = false
