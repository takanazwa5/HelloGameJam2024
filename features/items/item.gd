@tool
class_name Item extends Node3D


const HAND_ICON : Texture2D = preload("res://shared/icons/hand_icon.png")


var collision_object : CollisionObject3D


@export var camera : Camera3D
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
		assert(camera is Camera3D, "Camera not assigned for %s" % get_path())
		assert(item_res is ItemRes, "Item Resource not assigned for %s" % get_path())
		assert(_is_item_res_valid(item_res), "Item Resource %s invalid" % item_res.get_path())
		_connect_signals(self)

		SignalBus.camera_changed.connect(_on_camera_changed)


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


func _connect_signals(p_node: Node) -> void:
	if p_node is CollisionObject3D:
		p_node.mouse_entered.connect(_on_mouse_entered)
		p_node.mouse_exited.connect(_on_mouse_exited)
		p_node.input_event.connect(_on_input_event)
		collision_object = p_node
		return

	for child : Node in p_node.get_children():
		_connect_signals(child)


func _on_mouse_entered() -> void:
	SignalBus.change_cursor.emit(HAND_ICON)


func _on_mouse_exited() -> void:
	SignalBus.change_cursor.emit(null)


func _on_input_event(_p_camera: Node, p_event: InputEvent, \
_p_event_position: Vector3, _p_normal: Vector3, _p_shape_idx: int) -> void:

	if p_event is InputEventMouseButton \
	and p_event.button_index == MOUSE_BUTTON_LEFT \
	and p_event.pressed:

		SignalBus.item_clicked.emit(self)


func _on_camera_changed(_p_from: Camera3D, p_to: Camera3D) -> void:
	if p_to == camera:
		collision_object.input_ray_pickable = true
	else:
		collision_object.input_ray_pickable = false
