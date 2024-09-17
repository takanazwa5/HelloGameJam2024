class_name Interactable extends CollisionObject3D


@export var required_item : ItemRes = null
@export var cam : Camera3D


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned for %s" % get_path())


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if required_item is ItemRes and Global.item_in_hand == required_item:
			Global.item_slot.queue_free()
			Global.item_in_hand = null
			Input.set_custom_mouse_cursor(null)
			correct_item_used()

		elif required_item == null:
			interact()


func correct_item_used() -> void:
	print_debug("correct_item_used not overriden")


func interact() -> void:
	print_debug("interact not overriden")
