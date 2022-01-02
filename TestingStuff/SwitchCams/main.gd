extends Spatial

onready var Cameras = $Cameras
onready var CamLabel = $UI/Label

func _ready() -> void:
	CamLabel.text = "Cam " + Cameras.get_current_cam() as String

func rotate_cam_left() -> void:
	Cameras.rotate_cam_left()
	CamLabel.text = "Cam " + Cameras.get_current_cam() as String

func rotate_cam_right() -> void:
	Cameras.rotate_cam_right()
	CamLabel.text = "Cam " + Cameras.get_current_cam() as String
