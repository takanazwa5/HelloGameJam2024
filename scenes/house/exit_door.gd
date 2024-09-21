class_name ExitDoor extends Door


func _ready() -> void:
	super()

	Global.exit_door = self


func interact() -> void:
	print("GAME END")
