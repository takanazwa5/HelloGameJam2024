class_name Level extends Node3D


const FOOTSTEPS_ICON : Texture2D = preload("res://shared/icons/footsteps_icon.png")


func _ready() -> void:
	for _floor : StaticBody3D in [%LivingRoomFloor, %BathroomFloor]:
		_floor.input_event.connect(_on_floor_input_event)
		_floor.mouse_entered.connect(_on_floor_mouse_entered)
		_floor.mouse_exited.connect(_on_floor_mouse_exited)


func _on_floor_input_event(_camera: Camera3D, event: InputEvent, \
event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		SignalBus.floor_click.emit(event_position)


func _on_floor_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(FOOTSTEPS_ICON, Input.CURSOR_ARROW, Vector2(16, 16))


func _on_floor_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
