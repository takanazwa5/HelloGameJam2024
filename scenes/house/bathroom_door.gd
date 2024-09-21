class_name BathroomDoor extends Door


var first_entry : bool = true


func _ready() -> void:
	super()

	Global.bathroom_door = self

	DebugConsole.create_command("bathroom_get_key", func() -> void: has_key = true)


func interact() -> void:
	match get_viewport().get_camera_3d():

		Global.main_camera:
			if first_entry:
				first_entry = false
				%BathroomAnimations.play("FirstEntry")

			Global.main.change_camera(Global.bathroom_camera)

		Global.bathroom_camera:
			Global.main.change_camera(Global.main_camera)

		_:
			push_error("Something's fucked")
