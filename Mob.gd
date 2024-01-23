extends CharacterBody3D

# min and max speed of the monster in m/s
@export var min_speed = 10
@export var max_speed = 18
signal squashed
@export var squash_length_init = 25
var squash_length = squash_length_init
var squashing = false
var init_scale
var has_collision = true


func _physics_process(delta):
	move_and_slide()
	if squashing == true:
		if has_collision == true:
			has_collision = false
			$CollisionShape3D.queue_free()
		velocity = Vector3.ZERO
		$Pivot/Character.scale.y -= init_scale / squash_length_init
		$Pivot/Character.scale.x += (randf() - 0.5)
		$Pivot/Character.scale.z += (randf() - 0.5)
		squash_length -= 1
	if squash_length == 0:
		queue_free()


# This function will be called from the Main scene
func initialize(start_position, player_position):
	init_scale = $Pivot/Character.scale.y
	
	# Position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# Calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	
	# Calculate a forward velocity that represents the speed
	velocity = Vector3.FORWARD * random_speed
	
	# Then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking
	velocity = velocity.rotated(Vector3.UP, rotation.y)


# Using the "VisibleOnScreenNotifier" node signal "screen_exited", delete the monster
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()


# When the mob is squashed
func squash():
	squashed.emit()
	squashing = true
			
			
