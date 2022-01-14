extends Position3D


var cams = []
var cam_result = RegEx.new()
var current_cam = 0


func _ready() -> void:
	cam_result.compile("Room(?<Nr>[0-9]+)")
	cams = self.get_children()
	cams.sort()
	cams[current_cam].current = true


func _on_UI_swap_cam(forward: bool) -> void:
	if forward:
		current_cam += 1
		if current_cam == len(cams):
			current_cam = 0 # Wraparound
		cams[current_cam].current = true
	else:
		current_cam -= 1
		if current_cam == -1:
			current_cam = len(cams) - 1 # Wraparound
		cams[current_cam].current = true
