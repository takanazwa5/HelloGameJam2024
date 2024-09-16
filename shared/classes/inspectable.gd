class_name Inspectable extends CollisionObject3D


const CURSOR_MAGNIFYING_GLASS : Texture2D = preload("res://shared/icons/magnifying_glass_icon.png")


@export var cam : Camera3D
@export var area : Area3D


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned for %s" % get_path())
	assert(area is Area3D, "Area not assigned for %s" % get_path())

	area.body_entered.connect(on_area_body_entered)


func _mouse_enter() -> void:
	if not Global.item_in_hand == null or Global.player.inspecting:
		return

	Input.set_custom_mouse_cursor(CURSOR_MAGNIFYING_GLASS, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	if not Global.item_in_hand == null:
		return

	Input.set_custom_mouse_cursor(null)


func _input_event(_camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if Global.player.inspecting:
			return

		if Global.player in area.get_overlapping_bodies():
			Global.player.inspecting = true
			Global.player.input_dir = Vector2.ZERO
			Global.main.change_camera(cam)
			Global.player.freeroaming = false
			return

		Global.player.move_to_position(global_position)
		Global.player.moving_to_inspectable = true
		Global.player.freeroaming = false


func on_area_body_entered(body: Node3D) -> void:
	if body is Player and Global.player.moving_to_inspectable:
		Global.player.moving_to_inspectable = false
		Global.player.inspecting = true
		Global.player.input_dir = Vector2.ZERO
		Global.main.change_camera(cam)
