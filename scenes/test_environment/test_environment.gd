class_name TestEnvironment extends Node3D


const FOOTSTEPS_ICON : Texture2D = preload("res://shared/icons/footsteps_icon.png")


func _ready() -> void:
	%LivingRoomFloor.input_event.connect(on_ground_input_event)
	%BathroomFloor.input_event.connect(on_ground_input_event)
	%LivingRoomFloor.mouse_entered.connect(on_mouse_entered)
	%BathroomFloor.mouse_entered.connect(on_mouse_entered)
	%LivingRoomFloor.mouse_exited.connect(on_mouse_exited)
	%BathroomFloor.mouse_exited.connect(on_mouse_exited)


func on_mouse_entered() -> void:
	if get_viewport().get_camera_3d() in [Global.main_camera, Global.bathroom_camera]:
		Input.set_custom_mouse_cursor(FOOTSTEPS_ICON, Input.CURSOR_ARROW, Vector2(16, 16))


func on_mouse_exited() -> void:
	if get_viewport().get_camera_3d() in [Global.main_camera, Global.bathroom_camera]:
		Input.set_custom_mouse_cursor(null)


func on_ground_input_event(_camera: Node, event: InputEvent, \
event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if Global.player.inspecting:
			return

		Global.player.move_to_position(event_position)
		Global.player.moving_to_inspectable = false
		Global.player.freeroaming = true
