extends Node

# Debug stuff
var debug_level = 0 # Currently no effect yet
# TODO: Make this useful in other scripts

# Automatically set vars
var debug_out := true

# Vars used for global data transmission
var events_cleared := 0

var _list_name := "" # Used by _sort_by_number_helper

func sort_list_of_nodes_by_number_at_end(list: Array, initial_name: String) -> void:
	_list_name = initial_name
	list.sort_custom(Global, "_sort_by_number_helper")

func _sort_by_number_helper(first, second) -> bool:
	if not second.name:
		return true
	if not first.name:
		return false

	if not second.name is String:
		return true
	if not first.name is String:
		return false

	var regex = RegEx.new()
	regex.compile(_list_name + "(?<Nr>[0-9]+)")
	var first_num = regex.search(first.name)
	var second_num = regex.search(second.name)

	if not first_num:
		return true
	else:
		first_num = first_num.get_string() as int

	if not second_num:
		return false
	else:
		second_num = second_num.get_string() as int

	return first_num < second_num


func list_select_random(list: Array):
	return list[floor(rand_range(0, len(list)))]


func dict_select_random(dict: Dictionary):
	var keys = dict.keys()
	return dict[list_select_random(keys)]


func dict_select_random_key(dict: Dictionary):
	return list_select_random(dict.keys())


func _ready() -> void:
	debug_out = OS.has_feature("editor")
