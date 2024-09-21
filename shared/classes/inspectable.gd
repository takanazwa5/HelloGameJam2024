class_name Inspectable extends CollisionObject3D


const CURSOR_MAGNIFYING_GLASS : Texture2D = preload("res://shared/icons/magnifying_glass_icon.png")


@export var cam : Camera3D
@export var detection_area : Area3D
@export var interaction_area : Area3D
@export var marker : Marker3D


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned for %s" % get_path())
	assert(detection_area is Area3D, "Detection Area not assigned for %s" % get_path())
	assert(interaction_area is Area3D, "Interaction Area not assigned for %s" % get_path())
	assert(marker is Marker3D, "Marker not assigned for %s" % get_path())

	input_ray_pickable = false
	detection_area.input_ray_pickable = false
	interaction_area.input_ray_pickable = true
	detection_area.body_entered.connect(on_detection_area_body_entered)
	interaction_area.input_event.connect(on_interaction_area_input_event)
	interaction_area.mouse_entered.connect(on_interaction_area_mouse_entered)
	interaction_area.mouse_exited.connect(on_interaction_area_mouse_exited)


func on_interaction_area_mouse_entered() -> void:
	if not Global.item_in_hand == null or Global.player.inspecting:
		return

	Input.set_custom_mouse_cursor(CURSOR_MAGNIFYING_GLASS, Input.CURSOR_ARROW, Vector2(16, 16))


func on_interaction_area_mouse_exited() -> void:
	if not Global.item_in_hand == null:
		return

	Input.set_custom_mouse_cursor(null)


func on_interaction_area_input_event(_camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if get_viewport().get_camera_3d() == cam:
			return

		if Global.player.inspecting:
			return

		Global.moving_to = self

		if Global.player in detection_area.get_overlapping_bodies():
			inspect()
			return

		Global.player.move_to_position(marker.global_position)
		Global.player.moving_to_inspectable = true
		Global.player.freeroaming = false


func on_detection_area_body_entered(body: Node3D) -> void:
	if body is Player and Global.player.moving_to_inspectable and Global.moving_to == self:
		inspect()


func inspect() -> void:
	Global.player.inspecting = true
	Global.player.freeroaming = false
	Global.player.moving_to_inspectable = false
	Global.player.input_dir = Vector2.ZERO
	Global.main.change_camera(cam)
	interaction_area.input_ray_pickable = false
	Global.current_interaction_area = interaction_area
