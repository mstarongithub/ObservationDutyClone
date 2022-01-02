extends Spatial

export var min_update_duration := 10
export var max_update_duration := 20

onready var timer := $Timer

var potential_objects = {
	"hovers": [],
	"rotators": [],
	"hiders": []
}
var active_objects = {
	"hovers": [],
	"rotators": [],
	"hiders": []
}

var all_possible_events_count: int = 0
var active_objects_count: int = 0

func _ready() -> void:
	for obj in get_tree().get_nodes_in_group("hovering_objects"):
		potential_objects["hovers"].append(obj)
		all_possible_events_count += 1
	for obj in get_tree().get_nodes_in_group("rotating_object"):
		potential_objects["rotators"].append(obj)
		all_possible_events_count += 1
	for obj in get_tree().get_nodes_in_group("hiding_object"):
		potential_objects["hiders"].append(obj)
		all_possible_events_count += 1


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("force_activate_interaction"):
		print("Forced activation")
		activate_random_object()
	elif Input.is_action_just_pressed("clear_oldest_interaction"):
		print("Force deactivating an event")
		if len(active_objects["hovers"]) > 0:
			var obj = active_objects["hovers"].pop_front()
			obj.reset()
			active_objects_count -= 1
		elif len(active_objects["rotators"]) > 0:
			var obj = active_objects["rotators"].pop_front()
			obj.reset()
			active_objects_count -= 1
		elif len(active_objects["hiders"]) > 0:
			var obj = active_objects["hiders"].pop_front()
			obj.reset()
			active_objects_count -= 1
		else:
			print("Nothing to deactivate")


func list_select_random(list):
	return list[floor(rand_range(0, len(list)))]


func dict_select_random(dict: Dictionary):
	var keys = dict.keys()
	return dict[list_select_random(keys)]


func dict_select_random_key(dict: Dictionary):
	return list_select_random(dict.keys())


func activate_random_object():
	if active_objects_count == all_possible_events_count:
		print("Max events active")
		return

	var event_key = dict_select_random_key(potential_objects) # Choose event type
	var events = potential_objects[event_key] # Get events of that type

	while len(events) == len(active_objects[event_key]):
		# Are all objects with that event already active? Choose a new category
		event_key = dict_select_random_key(potential_objects)
		events = potential_objects[event_key]

	var new_active = list_select_random(events)
	while new_active in active_objects[event_key]:
		# Is the event chosen already active? If yes, choose new one
		new_active = list_select_random(events)

	# Add to active events and activate
	active_objects[event_key].append(new_active)
	active_objects_count += 1
	new_active.activate()


func _on_spawn_new_event() -> void:
	activate_random_object()
	timer.start(rand_range(min_update_duration, max_update_duration))


func _on_UI_kill_event(event_type) -> void:
	if len(active_objects[event_type]) <= 0:
		return
	var obj = active_objects[event_type].pop_front()
	active_objects_count -= 1
	obj.reset()
