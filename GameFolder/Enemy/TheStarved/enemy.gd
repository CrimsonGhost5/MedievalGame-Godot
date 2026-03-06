extends CharacterBody3D
class_name BaseEnemy

#All of this may change for a better basic enemy script


var player = null
var food = null


var speed = 5.0
var see_food = false
var damage = 1
var enemy_timer = 5.0

const attack_range = 2.0

@export var player_path : NodePath
@export var food_path : NodePath
#Change this too see how far the player can get knocked back
@export var knockback_force: float


@onready var nav_agent = $NavigationAgent3D
@onready var raycast = $RayCast 
@onready var foodraycast = $FoodRayCast
@onready var foodraycast2 = $FoodRayCast2
@onready var foodraycast3 = $FoodRayCast3
@onready var timer = $Timer
@onready var asp: AudioStreamPlayer3D = $AudioStreamPlayer3D

# animation stuff
@onready var material = $Body.get_active_material(0)
@onready var standSprite = load("res://Enemy/TheStarved/MunchyEnemy1.png")
@onready var walkSprite1 = load("res://Enemy/TheStarved/MunchyEnemy2.png")
var animating = false


func _ready() -> void:
	player = get_node(player_path)
	food = get_node(food_path)
	

func _physics_process(delta: float) -> void:
	#This is so the raycast is always looking at the player's position
	raycast.look_at(player.global_position, Vector3.UP)
	#This is so the raycast is always looking at the food's position
	#raycast.look_at(food.global_position, Vector3.UP)
	velocity = Vector3.ZERO
	asp.play()
	
	#Once the player gets close and collides with the raycast that's when everything happens
	if raycast.is_colliding():
		if raycast.get_collider() == player and see_food == false:
			##Creates a list of points or corwds for the enemy to get to its destination
			nav_agent.set_target_position(player.global_position)
			##Creates a variable to allow the enemy to get from point to point
			var next_player_nav_point = nav_agent.get_next_path_position()
			##Is what makes the enemy move
			velocity = (next_player_nav_point - global_position).normalized() * speed
			##The Model turns to look at the player
			look_at(Vector3(next_player_nav_point.x, global_position.y, next_player_nav_point.z), Vector3.UP)
			move_and_slide()
		#if foodraycast.get_collider() == food or foodraycast2.get_collider() == food or foodraycast3.get_collider() == food:
			#see_food = true
			#nav_agent.set_target_position(food.global_position)
			#var next_food_nav_point = nav_agent.get_next_path_position()
			#velocity = (next_food_nav_point - global_position).normalized() * speed
			#look_at(Vector3(next_food_nav_point.x, global_position.y, next_food_nav_point.z), Vector3.UP)
			#if not food or not is_instance_valid(food):
				#return
			#move_and_slide()
	
	# animate if velocity is moving
	if(self.velocity != Vector3(0, 0, 0) && animating == false):
		# animation
		animating = true
		animate(delta)
	# unanimate if standing still
	else: if(self.velocity == Vector3(0, 0, 0) && material.albedo_texture != standSprite):
		material.albedo_texture = standSprite
	
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 5.0, 0.12)

func animate(delta: float) -> void:
	material.albedo_texture = walkSprite1
	await get_tree().create_timer(20 * delta).timeout
	material.albedo_texture = standSprite
	await get_tree().create_timer(20 * delta).timeout
	animating = false


func _on_food_dectector_body_entered(body: Node3D) -> void:
	if body.is_in_group("thrown food"):
		timer.start()
		speed = 0
		
	 
	


func _on_timer_timeout() -> void:
	speed = 5
