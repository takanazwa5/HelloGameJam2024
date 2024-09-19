class_name Remote extends Interactable


var original_transform : Transform3D


func _ready() -> void:
	super()

	original_transform = global_transform

	Global.remote = self


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if not can_interact:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if required_item is ItemRes and Global.item_in_hand == required_item:
			Global.item_slot.queue_free()
			Global.item_in_hand = null
			Global.item_slot = null
			Input.set_custom_mouse_cursor(null)
			interact()

		elif required_item == null and Global.item_in_hand == null:
			interact()

		elif not Global.item_in_hand == required_item:
			Global.show_dialog("It's not working.", 1.0)


func interact() -> void:
	can_interact = false
	input_ray_pickable = false
