@tool
class_name Item extends Node3D


const HAND_ICON : Texture2D = preload("res://shared/icons/hand_icon.png")


@export var item_res : ItemRes:
	set(val):
		item_res = val

		if _is_item_res_valid(item_res):
			name = item_res.display_name.to_pascal_case()
			add_child(item_res.scene.instantiate())
			return

		name = "Item"
		if get_child_count() > 0:
			remove_child(get_child(0))


func _ready() -> void:
	if not Engine.is_editor_hint():
		assert(item_res is ItemRes, "Item Resource not assigned for %s" % get_path())
		assert(_is_item_res_valid(item_res), "Item Resource %s invalid" % item_res.get_path())
		_connect_signals(self)


func _is_item_res_valid(p_item_res: ItemRes) -> bool:
	if p_item_res == null:
		return false

	var properties : Array = [
		p_item_res.scene,
		p_item_res.display_name,
		p_item_res.thumbnail,
		p_item_res.icon
	]

	for property : Variant in properties:
		if typeof(property) == TYPE_NIL:
			return false
	return true


func _connect_signals(node: Node) -> void:
	if node is CollisionObject3D:
		node.mouse_entered.connect(_on_mouse_entered)
		node.mouse_exited.connect(_on_mouse_exited)
		node.input_event.connect(_on_input_event)

	for child : Node in node.get_children():
		_connect_signals(child)


func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(HAND_ICON, Input.CURSOR_ARROW, Vector2(16, 16))


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func _on_input_event(_camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		print("%s clicked" % name)
