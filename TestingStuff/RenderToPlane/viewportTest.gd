extends MeshInstance

export var ViewNr: int = 0

func _on_view1Button_RadioButtonPressed(_Group, ButtonNr) -> void:
	if ButtonNr == ViewNr:
		self.visible = true
		print("View ", ViewNr, " activated")
	else:
		self.visible = false
		print("View ", ViewNr, " deactivated")
