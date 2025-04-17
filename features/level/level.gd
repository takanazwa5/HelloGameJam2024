class_name Level extends Node3D


enum Room {LIVING_ROOM, BATHROOM}


const FOOTSTEPS_ICON : Texture2D = preload("res://shared/icons/footsteps_icon.png")


@onready var floors : Array[StaticBody3D] = [%LivingRoomFloor, %BathroomFloor]


func _ready() -> void:
	for _floor : StaticBody3D in floors:
		_floor.input_event.connect(_on_floor_input_event)
		_floor.mouse_entered.connect(_on_floor_mouse_entered)
		_floor.mouse_exited.connect(_on_floor_mouse_exited)

	SignalBus.navigation_to_inspectable_finished.connect(_on_navigation_to_inspectable_finished)
	SignalBus.back_button_pressed.connect(_on_back_button_pressed)
	SignalBus.bathroom_door_interaction.connect(_on_bathroom_door_interaction)


func _on_floor_input_event(_camera: Camera3D, event: InputEvent, \
event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		SignalBus.floor_click.emit(event_position)


func _on_floor_mouse_entered() -> void:
	SignalBus.change_cursor.emit(FOOTSTEPS_ICON)


func _on_floor_mouse_exited() -> void:
	SignalBus.change_cursor.emit(null)


func _on_navigation_to_inspectable_finished() -> void:
	_disable()


func _on_back_button_pressed() -> void:
	await SignalBus.camera_changed
	_enable()


func _on_bathroom_door_interaction() -> void:
	_disable()
	await SignalBus.camera_changed
	_enable()


func _disable() -> void:
	for _floor : StaticBody3D in floors:
			_floor.input_ray_pickable = false


func _enable() -> void:
	for _floor : StaticBody3D in floors:
			_floor.input_ray_pickable = true
