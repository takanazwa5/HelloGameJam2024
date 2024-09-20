class_name Keyhole extends Interactable


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if not can_interact:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if required_item is ItemRes:
			if Global.item_in_hand == required_item:
				Global.item_slot.queue_free()
				Global.item_in_hand = null
				Global.item_slot = null
				Input.set_custom_mouse_cursor(null)
				interact()

			elif not Global.item_in_hand == null:
				Global.show_dialog("I can't use it here.", 2.0)
				Input.set_custom_mouse_cursor(null)
				Global.item_slot.get_node("TextureButton").texture_normal = Global.item_slot.item_res.thumbnail
				Global.item_in_hand = null
				Global.item_slot = null

			else:
				Global.show_dialog("I need a key.", 1.0)

		elif required_item == null:
			if Global.item_in_hand == null:
				interact()

			else:
				Global.show_dialog("I can't use it here.", 2.0)
				Input.set_custom_mouse_cursor(null)
				Global.item_slot.get_node("TextureButton").texture_normal = Global.item_slot.item_res.thumbnail
				Global.item_in_hand = null
				Global.item_slot = null


func interact() -> void:
	%Drawer_2.locked = false
	set_script(null)
