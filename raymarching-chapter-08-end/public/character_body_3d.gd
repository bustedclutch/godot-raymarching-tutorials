extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#Add a ready function with a line to capture the mouse.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #Be sure to have an exit for this.
	
#Add this entire input block to handle the mouse movement as well as escape.
func _input(event) -> void:
	var wand_position = $Wand.global_position
	var wand_firing_direction = $Wand.global_basis.z * -1
	var wand_firing_length = 15
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("fire"):
		print("fire pressed")
		
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(wand_position, wand_position + wand_firing_direction * wand_firing_length)
		var result = space.intersect_ray(query)
		print(result)
		if result and result.collider is RigidBody3D:
			result.collider.apply_impulse(wand_firing_direction * 10)
	if event.is_action_pressed("pull"):
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(wand_position, wand_position + wand_firing_direction * wand_firing_length)
		var result = space.intersect_ray(query)
		if result and result.collider is RigidBody3D:
			result.collider.apply_impulse(wand_firing_direction * -10)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$GobotSkin.jump()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
#	Add the below line to drive run and idle animations:
	if is_on_floor():
		$GobotSkin.idle() if velocity.length() < 0.01 else $GobotSkin.run()
