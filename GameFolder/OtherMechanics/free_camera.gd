extends Camera3D

@export var acceleration = 25.0
@export var moveSpeed = 5.0
@export var mouseSpeed = 300.0

var velocity = Vector3.ZERO
var lookAngles = Vector2.ZERO

# When this boolean is true it will switch the controls from the player to the camera
var cam_control = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam_control = GameState.get_value("cam control")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.state["cam control"] == true:
		lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
		set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))
		var direction = updateDirection()
		if direction.length_squared() > 0:
			velocity += direction * acceleration * delta
		if velocity.length() > moveSpeed:
			velocity = velocity.normalized() * moveSpeed
		
		translate(velocity * delta)

func _input(event):
	# mouse rotation
	if GameState.state["cam control"] == true:
		if event is InputEventMouseMotion:
			lookAngles -= event.relative / mouseSpeed 

func updateDirection():
	# Gets direction to move the camera from an input
	var dir = Vector3()
	if Input.is_action_pressed("up"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("down"):
		dir += Vector3.BACK
	if Input.is_action_pressed("left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("right"):
		dir += Vector3.RIGHT
	if Input.is_action_pressed("jump"):
		dir += Vector3.UP
	if Input.is_action_pressed("crouch"):
		dir += Vector3.DOWN
	if dir == Vector3.ZERO:
		velocity = Vector3.ZERO
	
	return dir.normalized()
