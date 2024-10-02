class_name Inspectable extends CollisionObject3D


const MAGNIFYING_GLASS_ICON : Texture2D = preload("res://shared/icons/magnifying_glass_icon.png")


@export var camera : Camera3D


var waiting_for_player : bool = false


func _ready() -> void:
	assert(camera is Camera3D, "Camera not assigned for %s" % get_path())

	SignalBus.freeroaming_started.connect(_on_freeroaming_started)
	SignalBus.navigation_to_inspectable_finished.connect(_on_navigation_to_inspectable_finished)
	SignalBus.camera_changed.connect(_on_camera_changed)


func _mouse_enter() -> void:
	Input.set_custom_mouse_cursor(MAGNIFYING_GLASS_ICON, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	Input.set_custom_mouse_cursor(null)


func _input_event(_p_camera: Camera3D, p_event: InputEvent, \
_p_event_position: Vector3, _p_normal: Vector3, _p_shape_idx: int) -> void:

	if p_event is InputEventMouseButton \
	and p_event.button_index == MOUSE_BUTTON_LEFT \
	and p_event.pressed:

		SignalBus.inspectable_clicked.emit(global_position)
		waiting_for_player = true


func _on_navigation_to_inspectable_finished() -> void:
	if waiting_for_player:
		_inspect()
	waiting_for_player = false


func _on_freeroaming_started() -> void:
	waiting_for_player = false


func _on_camera_changed(p_from: Camera3D, _p_to: Camera3D) -> void:
	if p_from == camera:
		input_ray_pickable = true


func _inspect() -> void:
	input_ray_pickable = false
	SignalBus.change_camera.emit(camera)
