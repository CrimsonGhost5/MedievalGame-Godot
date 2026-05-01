extends CharacterBody3D

var health = 90
var SPEED = 5.0
const JUMP_VELOCITY = 4.5

#For camera
var sensitivity = 0.2
var controller_sensitivity = 0.9
var min_angle = -80
var max_angle = 90
var look_rot: Vector2

var crouch_height = 0.5
var stand_height: float
var crouch_transition = 8.0

#This var gets reset after a certain ammount
var eat_amount = 0
#This is checked to see how much the player has sprinted
var sprint_amount = 0
#When an enemy hits the player they get pushed back a bit
var push_back = 30.0
var knockback: Vector3 = Vector3.ZERO
var knockback_timer: float = 0.0
var knockback_resistance = 10
var y_speed := 0


var currentvel := Vector3.ZERO

var input_dir = Vector3.ZERO

var is_sprinting = false
var is_crouching: bool = false
var moving = true
var getting_hurt = false

# This signal triggers when the player is hit by an enemy
signal player_hit


@onready var game_over_ui = $CanvasLayer/GameOverScreen
@onready var foot_steps: AudioStreamPlayer3D = %FootSteps
 
var throwable_food = load("res://Interactables/thrownfood_item.tscn")
var bread_crumb = load("res://Objects/bread_crumb.tscn")
@onready var pos = $Head/Hand
@onready var head = $Head
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var bread_crumb_spawn_point: Node3D = $BreadCrumbSpawnPoint

@onready var ap: AnimationPlayer = $Head/AnimationPlayer
@export_range(5, 10, 0.1) var crouch_speed : float = 7.0

@onready var breadeat = $Audio/BreadEatAlt
@onready var breadeatalt = $Audio/BreadEatAlt
@onready var breadthrow = $Audio/BreadThrow
@onready var crouch_cast: ShapeCast3D = $ShapeCast3D


func _ready() -> void:
	PlayerManager.player = self
	$UI/Healthbar.health.value = GameState.get_value("health")
	$UI/HungerBar.hunger.value = GameState.get_value("hunger")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Player")
	stand_height = collision_shape.shape.height
	look_rot.x = head.rotation_degrees.x 
	look_rot.y = rotation_degrees.y 
	$Head/AnimationPlayer.play("headbob")
	# so that the shapecast3d doesn't detect the player collision so crouching can work
	crouch_cast.add_exception($".")

func _process(delta: float) -> void:
	var axis_y := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	if axis_y != 0:
		if abs(axis_y) > 0.2:
			if axis_y > 0:
				look_rot.x -= (axis_y * controller_sensitivity)
			elif axis_y < 0:
				look_rot.x -= (axis_y * controller_sensitivity)
	var axis_x := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	if axis_x != 0:
		if abs(axis_x) > 0.2:
			if axis_x > 0:
				look_rot.y -= (axis_x * controller_sensitivity)
			elif axis_x < 0:
				look_rot.y -= (axis_x * controller_sensitivity)
	look_rot.x = clamp(look_rot.x, min_angle, max_angle)
	
	
	
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and moving:
		if $Head/AnimationPlayer.speed_scale != 1.5:
			$Head/AnimationPlayer.speed_scale = 1.5
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if $Head/AnimationPlayer.speed_scale != 0.0:
			$Head/AnimationPlayer.speed_scale = 0.0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("sprint") and is_on_floor() and $UI/StaminaBar.stamina.value > 0 and is_crouching == false :
		SPEED = 10
		$UI/StaminaBar.stamina.value -= 1
		$UI/StaminaBar.can_regen = false
		$UI/StaminaBar.s_timer = 0
		is_sprinting = true
		sprint_amount += 1
		if $Head/AnimationPlayer.speed_scale != 2.0:
			$Head/AnimationPlayer.speed_scale = 2.0
	
	if GameState.state["running shoes"] == true:
		SPEED = 7
	
	
	if Input.is_action_just_released("sprint") or $UI/StaminaBar.stamina.value == 0:
		SPEED = 5
		is_sprinting = false
	
	if sprint_amount == 100:
		$UI/HungerBar.hunger.value -= 5
		sprint_amount = 0
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector3.ZERO
	
	if health <= 0 or $UI/HungerBar.hunger.value == 0:
		die()
	
	$UI/FoodAmount/CanvasLayer/Control/FoodText.text = str(GameState.state["food"])
	
	
	throw()
	drop()
	eat()
	got_hit(Vector3.BACK)
	 #So the camera doesn't glitch out if the player looks a certain direction
	head.rotation_degrees.x  = look_rot.x 
	rotation_degrees.y = look_rot.y  
	move_and_slide()
	if GameState.state["door key"] == false:
		$UI/DoorKey/CanvasLayer/Control/Label.visible = false
		$UI/DoorKey/CanvasLayer/Control/TextureRect.visible = false
	else:
		$UI/DoorKey/CanvasLayer/Control/Label.visible = true
		$UI/DoorKey/CanvasLayer/Control/TextureRect.visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and moving == true:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
	if event.is_action_pressed("crouch"):
			new_crouch()

func move(speed: float, acceleration: float, delta: float) -> void:
	velocity = lerp(velocity, input_dir * speed, acceleration * delta)

func new_crouch():
	if is_crouching == true and crouch_cast.is_colliding() == false:
		ap.play("crouch", -1, -crouch_speed)
		print("is crouching")
	elif is_crouching == false:
		ap.play("crouch", -1, crouch_speed)
		print("not crouching")

 
func throw():
	if Input.is_action_just_pressed("throw") and GameState.state["food"] > 0:
		GameState.set_value("food", GameState.get_value("food") - 1)
		var instance = throwable_food.instantiate()
		instance.position = $Head/Hand.global_position
		get_parent().add_child(instance)
		breadthrow.play()
		
		var force = -10
		var upDir = 3.5
		
		var player_direction = $Head.global_transform.basis.z.normalized()
		
		instance.apply_central_impulse(player_direction * force + Vector3(0, upDir, 0))

func drop():
	if Input.is_action_just_pressed("drop") and GameState.state["food"] > 0 and GameState.state["bread knife"] == true:
		GameState.set_value("food", GameState.get_value("food") - 1)
		var instance = bread_crumb.instantiate()
		instance.position = bread_crumb_spawn_point.global_position
		get_parent().add_child(instance)
		

func eat():
	if Input.is_action_just_pressed("eat") and GameState.state["food"] > 0:
		GameState.set_value("food", GameState.get_value("food") - 1)
		eat_amount += 1
		health += 5
		print(eat_amount)
		$UI/Healthbar.health.value += 15
		$UI/HungerBar.hunger.value += 10
		breadeatalt.play()
	
	if eat_amount >= 4:
		$UI/StaminaBar.base_max += 20
		$UI/StaminaBar.stamina.value += 20
		$UI/StaminaBar/TextureProgressBar.max_value += 20
		eat_amount = 0

func apply_knockback(direction: Vector3, force: float, knockback_duration: float) -> void:
	force = 8.0
	knockback += direction * force
	knockback_timer = knockback_duration

func die():
	moving = false
	game_over_ui.show_gameover()
	$UI/FoodAmount.visible = false
	$UI/StaminaBar.visible = false
	$UI/Healthbar.visible = false
	$UI/HungerBar.visible = false
	$UI/CrossHair.visible = false
	$UI/DoorKey.visible = false
	$UI/FoodAmount/CanvasLayer/Control/TextureRect.visible = false
	$UI/FoodAmount/CanvasLayer/Control/FoodText.visible = false

func got_hit(dir):
	if getting_hurt == true:
		health -= 30 
		GameState.set_value("health", $UI/Healthbar.health.value)
		$UI/Healthbar.health.value -= 30
		emit_signal("player_hit")
		velocity += dir * push_back
		getting_hurt = false
		await get_tree().create_timer(0.8).timeout



#This will most likely be changed but for now this how the player takes damage to Enemies
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		getting_hurt = true
	else:
		getting_hurt = false
	if body.is_in_group("EnemyRat"):
		print("Is in body")
		$UI/HungerBar.hunger.value -= 5

func _add_food_amount(value: Variant) -> void:
	GameState.set_value("food", GameState.get_value("food") + 1)


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "crouch":
		is_crouching = !is_crouching
