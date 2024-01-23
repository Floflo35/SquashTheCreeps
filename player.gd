extends CharacterBody3D

# How fast the player moves in m/s
@export var speed = 14
# The downward acceleration when in the air, in m/s square
@export var fall_acceleration = 75
# Vertical impulse of the jump
@export var jump_impulse = 20
# Vertical impulse in m/s when bouncing on a mob
@export var bounce_impulse = 16

signal squash

var target_velocity = Vector3.ZERO

# MOVEMENT
func _physics_process(delta):
	# Create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	# Check for each move input and update the direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards sthe floor.
		target_velocity.y -= fall_acceleration * delta
		
	# Jump
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			target_velocity.y = jump_impulse
		
		
	# If a direction input is pressed
	if direction != Vector3.ZERO:
		# Normalize the vector so diagonals are not faster
		direction = direction.normalized()
		# The pivot looks at a point in the vector's direction
		$Pivot.look_at(position + direction, Vector3.UP)
	
	
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	
	# Moving the character
	velocity = target_velocity
	move_and_slide()
	
	
	# Iterate through all collisions that occured this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		# If the collision is with ground, ignore it
		if collision.get_collider() == null:
			continue
			
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Are we hitting it from above?
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				squash.emit()
				target_velocity.y = bounce_impulse
				break
