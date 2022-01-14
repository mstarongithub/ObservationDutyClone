extends Spatial

export var hover_active: bool = false
export var hover_speed: float = 1
export var hover_height: float = 1

onready var start_pos = translation


func activate():
	hover_active = true

func reset():
	hover_active = false
	translation = start_pos


func _process(delta: float) -> void:
	if hover_active:
		var new_y = sin(OS.get_unix_time() * hover_speed) * hover_height * delta
		translation = Vector3(
			start_pos.x,
			move_toward(translation.y, start_pos.y + hover_height, new_y),
			start_pos.z)
