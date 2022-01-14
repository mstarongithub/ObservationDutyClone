extends Position3D


class_name GameRoom


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
	var children = get_children()
	for child in children:
		if child.is_in_group("hovering_objects"):
			potential_objects["hovers"].append(child)
			all_possible_events_count += 1
		elif child.is_in_group("rotating_object"):
			potential_objects["rotators"].append(child)
			all_possible_events_count += 1
		elif child.is_in_group("hiding_object"):
			potential_objects["hiders"].append(child)
			all_possible_events_count += 1


func get_max_event_count():
	return all_possible_events_count


func is_max_active():
	return active_objects_count >= all_possible_events_count


func list_select_random(list):
	return list[floor(rand_range(0, len(list)))]


func dict_select_random(dict: Dictionary):
	var keys = dict.keys()
	return dict[list_select_random(keys)]


func dict_select_random_key(dict: Dictionary):
	return list_select_random(dict.keys())


func activate_random_object():
	if active_objects_count == all_possible_events_count:
		if Global.debug_out:
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
	if Global.debug_out:
		print("Activating ", new_active.name, " of type ", event_key, " in room ", name)
	active_objects_count += 1
	new_active.activate()


func deactivate_object_of_type(type: String) -> bool:
	if len(active_objects[type]) > 0:
		if Global.debug_out:
			print("Deactivating object of type ", type, " in room ", name)
		var obj = active_objects[type].pop_back()
		active_objects_count -= 1
		obj.reset()
		return true
	elif Global.debug_out:
		print("Nothing to deactivate in room ", name)

	return false
