class_name Item extends Interactable


@export var item_res : ItemRes


func _ready() -> void:
	super()
	assert(item_res is ItemRes, "Item Resource not assigned for %s" % get_path())


func _mouse_enter() -> void:
	if not Global.item_in_hand == null:
		return

	if cam.is_current():
		Input.set_custom_mouse_cursor(CURSOR_HAND, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	if not Global.item_in_hand == null:
		return

	Input.set_custom_mouse_cursor(null)

func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		SignalBus.item_picked_up.emit(self)
