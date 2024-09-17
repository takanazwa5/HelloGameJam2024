class_name CupboardShelves extends Node3D


@export var cam : Camera3D
@export var collision_object : CollisionObject3D


var original_position : Vector3 = Vector3.ZERO
var open : bool = false


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned to %s" % get_path())
	assert(collision_object is CollisionObject3D, "Static body not assigned to %s" % get_path())

	original_position = position

	collision_object.mouse_entered.connect(on_drawer_mouse_entered)
	collision_object.mouse_exited.connect(on_drawer_mouse_exited)
	collision_object.input_event.connect(on_drawer_input_event)

	Global.cupboard_shelves.append(self)


func on_drawer_mouse_entered() -> void:
	if cam.is_current():
		Input.set_custom_mouse_cursor(Item.CURSOR_HAND, Input.CURSOR_ARROW, Vector2(16, 16))


func on_drawer_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func on_drawer_input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		var tween : Tween = get_tree().create_tween()

		if not open:
			open = true
			tween.tween_property(self, "position", original_position + Vector3(0.0, 0.0, 0.4), 0.5)

		else:
			open = false
			tween.tween_property(self, "position", original_position, 0.5)
