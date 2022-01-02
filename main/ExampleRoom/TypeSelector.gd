extends GridContainer


var currently_selected: int = 0


func hide():
	visible = false

func show():
	visible = true



func _on_type_switch(_Group: String, ButtonNr: int) -> void:
	currently_selected = ButtonNr
