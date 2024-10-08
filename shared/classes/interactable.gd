class_name Interactable extends CollisionObject3D


const HAND_ICON : Texture2D = preload("res://shared/icons/hand_icon.png")


@export var required_item : ItemRes
@export var camera : Camera3D
@export_multiline var no_item_dialog : String = ""


func _ready() -> void:
	assert(camera is Camera3D, "Camera not assigned for %s" % get_path())

	input_ray_pickable = false

	SignalBus.camera_changed.connect(_on_camera_changed)


func _mouse_enter() -> void:
	SignalBus.change_cursor.emit(HAND_ICON)


func _mouse_exit() -> void:
	SignalBus.change_cursor.emit(null)


func _input_event(_p_camera: Node, p_event: InputEvent, \
_p_event_position: Vector3, _p_normal: Vector3, _p_shape_idx: int) -> void:

	if p_event is InputEventMouseButton \
	and p_event.button_index == MOUSE_BUTTON_LEFT \
	and p_event.pressed:

		if required_item is not ItemRes:
			interact()
			return

		SignalBus.interactable_clicked.emit(self)


func interact() -> void:
	print_debug("interact not overriden")


func _on_camera_changed(_p_from: Camera3D, p_to: Camera3D) -> void:
	if p_to == camera:
		input_ray_pickable = true
	else:
		input_ray_pickable = false
