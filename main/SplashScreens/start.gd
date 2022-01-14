extends Control

onready var main_menu := $MainMenu
onready var level_select := $LevelSelect

func _ready():
	randomize() # Initialize random seed

# ---------------------------------------------------------
# Main menu

func _main_to_level():
	main_menu.visible = false
	level_select.visible = true


func _quit():
	get_tree().quit()

# ---------------------------------------------------------
# Level select screen

func _start_new_example():
	var err = get_tree().change_scene("res://main/ExampleRebuilt/ExampleRebuilt.tscn")
	if err != OK:
		get_tree().quit(err)


func _start_old_example():
	var err = get_tree().change_scene("res://main/ExampleRoom/example_room.tscn")
	if err != OK:
		get_tree().quit(err)


func _level_to_main():
	level_select.visible = false
	main_menu.visible = true
