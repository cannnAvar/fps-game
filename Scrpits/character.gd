extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Adding low jump
	if Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0

	if Input.is_action_pressed("shoot") and $GunTimer.is_stopped():
		shoot_bullet()

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.5
		$Camera3D.rotation_degrees.x -= event.relative.y * 0.2
		$Camera3D.rotation_degrees.x = clamp(
			$Camera3D.rotation_degrees.x, -80.0, 80.0
			)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)




func shoot_bullet():
	const BULLET = preload("res://player/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	get_parent().add_child(new_bullet)
	new_bullet.global_transform = %Marker3D.global_transform
	
	$GunTimer.start()
