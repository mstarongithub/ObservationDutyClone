extends Position3D


onready var cams = [
	$Cam1,
	$Cam2,
	$Cam3,
]

var current_cam = 0


func get_current_cam() -> int:
	return current_cam

func swap_cam(cam_nr: int) -> void:
	current_cam = cam_nr
	cams[cam_nr].current = true

func rotate_cam_left() -> void:
	if current_cam == 0:
		swap_cam(len(cams) - 1)
	else:
		swap_cam(current_cam - 1)

func rotate_cam_right() -> void:
	if current_cam == len(cams) - 1:
		swap_cam(0)
	else:
		swap_cam(current_cam + 1)
