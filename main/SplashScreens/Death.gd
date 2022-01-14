extends Control

onready var events_cleared = $EventsCleared

func _ready() -> void:
	$EventsCleared.text = "You cleared " + Global.events_cleared as String + " events"



func _on_MainMenu_pressed() -> void:
	var err = get_tree().change_scene("res://main/SplashScreens/Start.tscn")
	if err != OK:
		get_tree().quit(err)
