extends Spatial


export var min_update_duration := 10
export var max_update_duration := 20
export var max_active_events_before_death := 4
export var death_countdown := 10

onready var timer := $NewEventTimer
onready var death_timer := $DeathTimer
onready var UI := $UI


var all_possible_events_count: int = 0
var active_objects_count: int = 0
var rooms := []
var events_cleared := 0
var event_types := []
var current_cam := 0
var cams := []

func _ready() -> void:
	var children := get_children()
	children.sort()
	for child in children:
		if child is BaseRoom:
			rooms.append(child)
			all_possible_events_count += child.get_max_event_count()
	Global.sort_list_of_nodes_by_number_at_end(rooms, "Room")
	Global.events_cleared = 0

	var r_names = []
	for room in rooms:
		r_names.append(room.name)
		var event_types_local = room.get_event_types()
		for event_type in event_types_local:
			if not (event_type as String) in event_types:
				event_types.append(event_type as String)

		cams.append(room.get_cam())
	cams[0].current = true
	UI.setup(event_types, r_names)

	timer.start(rand_range(min_update_duration, max_update_duration))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("force_activate_interaction"):
		if Global.debug_out:
			print("Forced activation")
		activate_random_object()
	elif Input.is_action_just_pressed("clear_oldest_interaction"):
		# TODO: Implement this
		if Global.debug_out:
			print("Force deactivating an event")


func activate_random_object():
	if active_objects_count == all_possible_events_count:
		return
	var room = Global.list_select_random(rooms)
	var checked = []
	while len(checked) <= len(rooms) and room.is_max_active():
		if not room in checked:
			checked.append(room)
		room = Global.list_select_random(rooms)
	if len(checked) >= len(rooms):
		if Global.debug_out:
			print("Can't activate any more events")
		return

	if Global.debug_out:
		print("Activating random object in ", room.name)
	active_objects_count += 1
	room.activate_random_object()


func _on_spawn_new_event() -> void:
	activate_random_object()
	if active_objects_count >= max_active_events_before_death:
		death_timer.start(death_countdown)
		UI.activate_death_warning()
	timer.start(rand_range(min_update_duration, max_update_duration))


func _on_UI_kill_event(event_type: String, room_nr: int) -> void:
	if rooms[room_nr].deactivate_object_of_type(event_type):
		Global.events_cleared += 1
		active_objects_count -= 1
		UI.successful_clear()
	else:
		UI.failed_clear()


func _on_DeathTimer_timeout() -> void:
	if active_objects_count < max_active_events_before_death:
		return
	if Global.debug_out:
		print("Death timer timeout")
	var err = get_tree().change_scene("res://main/SplashScreens/Death.tscn")
	if err != OK:
		get_tree().quit(err)


func _on_VictoryTimer_timeout() -> void:
	var err = get_tree().change_scene("res://main/SplashScreens/Victory.tscn")
	if err != OK:
		get_tree().quit(err)


func _on_UI_swap_cam(forward) -> void:
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

	UI.set_current_cam_name(current_cam)
