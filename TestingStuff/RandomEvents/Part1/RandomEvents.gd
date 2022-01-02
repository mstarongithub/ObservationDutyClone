extends Spatial

var cub = preload("res://MiniObjects/RedCube.tscn")

var active_events = []

func spawn_obj():
	var boundary_x = [-5, 5]
	var boundary_y = [-5, 5]
	var pos_x = rand_range(boundary_x[0], boundary_x[1])
	var pos_y = rand_range(boundary_y[0], boundary_y[1])

	var new_cub = cub.instance()
	new_cub.translation = Vector3(pos_x, 0.5, pos_y)
	self.add_child(new_cub)
	active_events.push_front(new_cub)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_test_cube"):
		spawn_obj()
