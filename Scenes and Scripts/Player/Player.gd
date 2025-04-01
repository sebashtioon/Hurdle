extends CharacterBody3D

@export_group("Node References")
@export_subgroup("General")
@export var Camera : Camera3D
@export var Camera_Controller : Node3D

@export_group("Properties")
@export var SPEED : float = 3.0
@export var JUMP_VELOCITY : float = 4.5
@export var GRAVITY : float = 12
@export var SENSITIVITY : float = 0.001

var is_moving : bool = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Camera_Controller.rotate_y(-event.relative.x * SENSITIVITY)
		Camera.rotate_x(-event.relative.y * SENSITIVITY)
		Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("MVM_Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("MVM_Left", "MVM_Right", "MVM_Forward", "MVM_Backward")
	var direction = (Camera_Controller.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)
	
	
	is_moving = velocity.length() > 1 and is_on_floor()
	
	
	move_and_slide()
	

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
