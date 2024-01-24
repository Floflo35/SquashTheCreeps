extends Node

@export var mob_scene: PackedScene


func _ready():
	$UI/Retry.hide()


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene
	add_child(mob)
	
	# Sends a signal to the ScoreLabel to call the function "_on_mob_squashed"
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobTimer.stop()
	$UI/Retry/Label.set_text("Score: %s \n Press Enter to Retry" % $UI/ScoreLabel.score)
	$UI/Retry.show()
	$UI/GameOverSound.playing = true
	

func _unhandled_input(event):
	if event.is_action_released("ui_accept") and $UI/Retry.visible:
		# Restart the scene
		get_tree().reload_current_scene()
