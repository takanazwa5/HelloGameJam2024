class_name Interactable extends CollisionObject3D


@export var can_interact : bool = true
@export var required_item : ItemRes = null
@export var cam : Camera3D


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned for %s" % get_path())

	collision_layer = 0b10


func _mouse_enter() -> void:
	if not can_interact:
		return

	if cam.is_current() and Global.item_in_hand == null:
		Input.set_custom_mouse_cursor(Item.CURSOR_HAND, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	if not can_interact:
		return

	if Global.item_in_hand is ItemRes:
		return

	Input.set_custom_mouse_cursor(null)


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
	print_debug("interact not overriden")
