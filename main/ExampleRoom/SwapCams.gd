extends Position3D



var cams = []
var cam_result = RegEx.new()
var current_cam = 0


func sort_cams(cam1: String, cam2: String) -> bool:
	var cam1_end = cam_result.search(cam1)
	var cam2_end = cam_result.search(cam2)

	# If one of the values doens't match the pattern, it goes in the back
	if not cam1_end:
		return false
	if not cam2_end:
		return true

	var cam1_nr_str: String = cam1_end.get_string("Nr")
	var cam2_nr_str: String = cam2_end.get_string("Nr")

	# Same thing here. If the end is not a valid int, it goes in the back
	if not cam1_nr_str.is_valid_integer():
		return false
	if not cam2_nr_str.is_valid_integer():
		return true

	return cam1_nr_str as int < cam2_nr_str as int


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
