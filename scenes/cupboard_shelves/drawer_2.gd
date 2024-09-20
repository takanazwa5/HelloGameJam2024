class_name Drawer2 extends CupboardShelves


var locked : bool = true


func on_drawer_input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if locked:
			Global.show_dialog("It's locked.", 1.0)
			return

		var tween : Tween = get_tree().create_tween()

		if not open:
			open = true
			tween.tween_property(self, "position", original_position + Vector3(0.0, 0.0, 0.4), 0.5)

		else:
			open = false
			tween.tween_property(self, "position", original_position, 0.5)
