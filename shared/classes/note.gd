class_name Note extends Interactable


@export var target_pos : Vector3 = Vector3.ZERO
@export var target_rot : Vector3 = Vector3.ZERO


var original_transform : Transform3D


func _ready() -> void:
	super()

	assert(not target_pos == Vector3.ZERO, "Target pos not set for %s" % get_path())
	assert(not target_rot == Vector3.ZERO, "Target rot not set for %s" % get_path())

	original_transform = transform


func _mouse_enter() -> void:
	if not can_interact:
		return

	if cam.is_current() and Global.item_in_hand == null and Global.current_note == null:
		Input.set_custom_mouse_cursor(Inspectable.CURSOR_MAGNIFYING_GLASS, Input.CURSOR_ARROW, Vector2(16, 16))


func interact() -> void:
	Global.current_note = self

	position = target_pos
	rotation_degrees = target_rot
