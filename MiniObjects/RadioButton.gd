extends CheckBox

class_name RadioButton


export var RadioNr: int = 0

var RadioGroupName: String = ""

signal RadioButtonPressed(Group, ButtonNr)

func _ready() -> void:
	# Auto-detect radio button group and save it
	for group in get_groups():
		if group.begins_with("RadioButton"):
			RadioGroupName = group as String

func incoming_RadioButton_disable():
	pressed = false

func _on_RadioButton_pressed() -> void:
	# Use realtime call to avoid a race condition where the button disables itself the next frame
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, RadioGroupName, "incoming_RadioButton_disable")
	pressed = true
	emit_signal("RadioButtonPressed", RadioGroupName, RadioNr)
