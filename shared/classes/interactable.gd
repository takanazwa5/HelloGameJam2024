class_name Interactable extends CollisionObject3D


const CURSOR_HAND : Texture2D = preload("res://shared/icons/hand_icon.png")
const CURSOR_MAGNIFYING_GLASS : Texture2D = preload("res://shared/icons/magnifying_glass_icon.png")


@export var can_interact : bool = true
@export var cam : Camera3D


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned for %s" % get_path())


func _mouse_enter() -> void:
	if not Global.item_in_hand == null:
		return

	if not cam.is_current():
		Input.set_custom_mouse_cursor(CURSOR_MAGNIFYING_GLASS, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	if not Global.item_in_hand == null:
		return

	Input.set_custom_mouse_cursor(null)


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if camera == cam:
			return

		SignalBus.activate_camera.emit(cam)
