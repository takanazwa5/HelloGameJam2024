class_name Door extends CollisionObject3D


const CURSOR_DOOR : Texture2D = preload("res://shared/icons/door_icon.png")
const CURSOR_KEY : Texture2D = preload("res://shared/icons/key_icon.png")


@export var detection_area : Area3D
@export var marker : Marker3D
@export var has_key : bool = false
@export var dialog_when_locked : String = ""


func _ready() -> void:
	assert(detection_area is Area3D, "Detection Area not assigned for %s" % get_path())
	assert(marker is Marker3D, "Marker not assigned for %s" % get_path())
	assert(not dialog_when_locked.is_empty(), "Door dialog text not set for %s" % get_path())

	detection_area.input_ray_pickable = false
	detection_area.body_entered.connect(on_detection_area_body_entered)


func _mouse_enter() -> void:
	if Global.main_camera.is_current() or Global.bathroom_camera.is_current():

		if has_key:
			Input.set_custom_mouse_cursor(CURSOR_DOOR, Input.CURSOR_ARROW, Vector2(16, 16))

		else:
			Input.set_custom_mouse_cursor(CURSOR_KEY, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	if Global.main_camera.is_current() or Global.bathroom_camera.is_current():
		Input.set_custom_mouse_cursor(null)


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if Global.player in detection_area.get_overlapping_bodies():
			Global.player.input_dir = Vector2.ZERO

			if camera in [Global.main_camera, Global.bathroom_camera]:

				if has_key:
					interact()

				else:
					Global.show_dialog(dialog_when_locked, 2.0)

			return

		Global.player.move_to_position(marker.global_position)
		Global.player.moving_to_inspectable = true


func on_detection_area_body_entered(body: Node3D) -> void:
	if body is Player and Global.player.moving_to_inspectable:
		Global.player.moving_to_inspectable = false
		Global.player.input_dir = Vector2.ZERO

		if get_viewport().get_camera_3d() in [Global.main_camera, Global.bathroom_camera]:

			if has_key:
				interact()

			else:
				Global.show_dialog(dialog_when_locked, 2.0)


func interact() -> void:
	push_warning("interact() not overriden for %s" % get_path())
