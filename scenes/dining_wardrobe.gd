class_name DiningWardrobe extends Inspectable


var first_inspection : bool = true


func _ready() -> void:
	super()

	Global.dining_wardrobe = self


func inspect() -> void:
	super()

	if first_inspection:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		await Global.main.get_node("%Animations").animation_finished
		Global.show_dialog("Strange... This one is also broken.", 5.0)
		await Global.dialog_timer.timeout
		Global.show_dialog("Maybe I'll try replacing the batteries.", 5.0)
		await Global.dialog_timer.timeout
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
