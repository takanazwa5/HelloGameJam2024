class_name BathroomKey extends Item


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if Global.item_in_hand is ItemRes:
			return

		Global.key_pickup.play()
		Global.bathroom_door.has_key = true
		%NoteWaterArea.show()
		%DoorKnocking.play()
		Global.inventory.add_item(self)
