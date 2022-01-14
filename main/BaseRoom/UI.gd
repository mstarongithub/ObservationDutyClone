extends Control

class_name BaseUI


signal kill_event(event_type, room_nr)
signal swap_cam(forward)

export var submit_duration := 5

var current_type_nr: int = 0
var event_types := []
var current_room: int = 0
var room_names := []

onready var event_selection_window := $StopEventButtons
onready var event_selection_open := $OpenEventSelector
onready var death_warning := $DeathWarning
onready var submit_timer := $SubmitTimer
onready var submit_button := $Submitting
onready var sucess_note := $SucessfulDeactivation
onready var sucess_timer := $SucessfulDeactivation/Timer
onready var fail_note := $FailedDeactivation
onready var fail_timer := $FailedDeactivation/Timer
onready var room_name_note := $RoomName
onready var RadioButton := preload("res://MiniObjects/RadioButton.tscn")


func setup(types: Array, r_names: Array):
	event_types = types
	for type_pos in range(0, len(event_types)):
		var type = event_types[type_pos]
		var event_button = RadioButton.instance()
		event_button.name = "Event" + type
		event_button.text = type
		event_button.add_to_group("RadioButtonEvents")
		event_button.RadioNr = type_pos
		event_button.connect("RadioButtonPressed", self, "_on_type_switch")
		if type_pos == 0:
			event_button.pressed = true
		$StopEventButtons/TypeSelector.add_child(event_button)

	room_names = r_names
	for r_name_pos in range(len(room_names)):
		var event_button = RadioButton.instance()
		var r_name = room_names[r_name_pos]
		event_button.name = r_name
		event_button.text = r_name
		event_button.add_to_group("RadioButtonRooms")
		event_button.RadioNr = r_name_pos
		event_button.connect("RadioButtonPressed", self, "_on_room_switch")
		if r_name_pos == 0:
			event_button.pressed = true
		$StopEventButtons/RoomSelector.add_child(event_button)

	set_current_cam_name(0)


func set_current_cam_name(cam_nr: int):
	room_name_note.text = room_names[cam_nr]


func activate_death_warning():
	death_warning.visible = true


func successful_clear():
	sucess_note.visible = true
	sucess_timer.start()


func failed_clear():
	fail_note.visible = true
	fail_timer.start()


func button_back_pressed():
	emit_signal("swap_cam", false)


func button_forward_pressed():
	emit_signal("swap_cam", true)


func _on_type_switch(_Group: String, ButtonNr: int) -> void:
	current_type_nr = ButtonNr


func _on_room_switch(_Group: String, ButtonNr: int) -> void:
	current_room = ButtonNr


func _on_CancelEvent_pressed() -> void:
	event_selection_window.visible = false
	event_selection_open.visible = true


func _on_OpenEventSelector_pressed() -> void:
	event_selection_open.visible = false
	event_selection_window.visible = true


func _on_ConfirmEvent_pressed() -> void:
	submit_timer.start(submit_duration)
	submit_button.visible = true
	event_selection_window.visible = false


func _on_SubmitTimer_timeout() -> void:
	if Global.debug_out:
		print("Attempting to kill event ", event_types[current_type_nr], " in ", current_room)
	emit_signal("kill_event", event_types[current_type_nr], current_room)
	event_selection_open.visible = true
	submit_button.visible = false


func _on_SucessfulTimer_timeout() -> void:
	sucess_note.visible = false


func _on_FailedTimer_timeout() -> void:
	sucess_note.visible = false
