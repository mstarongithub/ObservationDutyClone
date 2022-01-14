extends Control

onready var events := $EventsCleared

func _ready() -> void:
	events.text = "Events cleared: " + Global.events_cleared as String


func _on_ReturnButton_pressed() -> void:
	var err = get_tree().change_scene("res://main/SplashScreens/Start.tscn")
	if err != OK:
		get_tree().quit(err)
