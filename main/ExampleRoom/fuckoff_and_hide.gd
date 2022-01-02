extends Spatial

func activate():
	print("Activating" + name as String)
	visible = false

func reset():
	print("Dectivating" + name as String)
	visible = true
