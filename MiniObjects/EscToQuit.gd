extends Label


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_ESCAPE:
		get_tree().quit()
