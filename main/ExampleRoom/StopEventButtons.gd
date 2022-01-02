extends Control


var currently_selected: int = 0


func _on_type_switch(_Group: String, ButtonNr: int) -> void:
	currently_selected = ButtonNr
