extends Spatial


export var rotation_active: bool = false
export var rotation_speed: float = 5

onready var default_rotation = rotation

func activate():
	print("Activating" + name as String)
	rotation_active = true


func reset():
	print("Deactivating" + name as String)
	rotation_active = false
	rotation = default_rotation


func _physics_process(delta: float) -> void:
	if rotation_active:
		rotate_y(deg2rad(rotation_speed*delta))
