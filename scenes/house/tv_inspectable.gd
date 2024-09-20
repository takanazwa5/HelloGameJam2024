class_name TVInspectable extends Inspectable


func _ready() -> void:
	super()

	Global.tv_cam = cam


func inspect() -> void:
	super()

	if Global.has_remote:
		%Remote.position = Vector3(8.918, 1.46, -1.295)
		%Remote.rotation_degrees = Vector3(71.0, -29.6, 0.0)

	else:
		await get_tree().create_timer(1.0).timeout
		Global.show_dialog("I need a remote.", 2.0)
