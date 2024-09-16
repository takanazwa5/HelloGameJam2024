class_name Enviro extends Node3D


func _ready() -> void:
	%Ground.input_event.connect(on_ground_input_event)


func on_ground_input_event(_camera: Node, event: InputEvent, \
event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		SignalBus.ground_click.emit(event_position)
