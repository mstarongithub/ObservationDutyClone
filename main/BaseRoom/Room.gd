extends Position3D


class_name BaseRoom

export var event_types := ["hovering", "rotating", "hiding"]

var potential_objects := {}
var active_objects := {}

var all_possible_events_count: int = 0
var active_objects_count: int = 0


func _ready() -> void:
	var children := get_children()
	for event_type in event_types:
		potential_objects[event_type] = []
		active_objects[event_type] = []
		for child in children:
			if child.is_in_group(event_type):
				potential_objects[event_type].append(child)
				all_possible_events_count += 1


func get_max_event_count() -> int:
	return all_possible_events_count


func get_event_types() -> Array:
	return event_types


func get_cam():
	return $Camera


func is_max_active() -> bool:
	return active_objects_count >= all_possible_events_count


func activate_random_object():
	if active_objects_count == all_possible_events_count:
		if Global.debug_out:
			print("Max events active")
		return

	var event_key = Global.list_select_random(event_types) # Choose event type
	var events = potential_objects[event_key] # Get events of that type

	while len(events) == len(active_objects[event_key]):
		# Are all objects with that event already active? Choose a new category
		event_key = Global.list_select_random(event_types)
		events = potential_objects[event_key]

	var new_active = Global.list_select_random(events)
	while new_active in active_objects[event_key]:
		# Is the event chosen already active? If yes, choose new one
		new_active = Global.list_select_random(events)

	# Add to active events and activate
	active_objects[event_key].append(new_active)
	if Global.debug_out:
		print("Activating ", new_active.name, " of type ", event_key, " in room ", name)
	active_objects_count += 1
	new_active.activate()


func deactivate_object_of_type(type: String) -> bool:
	if not type in event_types:
		return false

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
