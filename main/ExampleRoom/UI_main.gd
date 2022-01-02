extends Control

var currently_selected: int = 0
var event_types = [
	"hovers",
	"rotators",
	"hiders"
]

signal kill_event(event_type)

onready var event_selection_window = $StopEventButtons
onready var event_selection_open = $OpenEventSelector

signal swap_cam(forward)

func button_back_pressed():
	emit_signal("swap_cam", false)


func button_forward_pressed():
	emit_signal("swap_cam", true)


func _on_type_switch(_Group: String, ButtonNr: int) -> void:
	currently_selected = ButtonNr


func _on_CancelEvent_pressed() -> void:
	event_selection_open.visible = true
	event_selection_window.visible = false


func _on_OpenEventSelector_pressed() -> void:
	event_selection_open.visible = false
	event_selection_window.visible = true


func _on_ConfirmEvent_pressed() -> void:
	emit_signal("kill_event", event_types[currently_selected])
	_on_CancelEvent_pressed()
