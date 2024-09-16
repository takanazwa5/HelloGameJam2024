class_name InteractableWithItem extends Interactable


@export var required_item : ItemRes


func _ready() -> void:
	super()
	assert(required_item is ItemRes, "Required Item not assigned for %s" % get_path())


func _mouse_enter() -> void:
	pass


func _mouse_exit() -> void:
	pass


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if Global.item_in_hand == required_item:
			Global.item_slot.queue_free()
			Global.item_in_hand = null
			Input.set_custom_mouse_cursor(null)
			correct_item_used()


func correct_item_used() -> void:
	print_debug("correct_item_used not overriden")
