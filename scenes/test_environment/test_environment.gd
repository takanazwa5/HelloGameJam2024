class_name TestEnvironment extends Node3D


func _ready() -> void:
	%LivingRoomFloor.input_event.connect(on_ground_input_event)
	%BathroomFloor.input_event.connect(on_ground_input_event)


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
