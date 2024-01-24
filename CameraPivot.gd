extends Marker3D

@export var shake_duration = 0.2
@export var shake_intensity = 10
var shake_transform = Vector3.ZERO
var init_pos
var shake_time = 0

var shake = false

func _physics_process(delta):
	if shake == true:
		if shake_time >= shake_duration:
			shake = false
			shake_time = 0
			shake_transform = Vector3.ZERO
			$Camera3D.position = init_pos
		else:
			$Camera3D.position.x = (randf() - 0.5) * shake_intensity / 10
			$Camera3D.position.y = (randf() - 0.5) * shake_intensity / 10
			shake_time += delta
			#print("time: ", shake_time)


func _enter_tree():
	init_pos = $Camera3D.position
	shake_transform = init_pos


func _on_player_squash():
	shake = true
