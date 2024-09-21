extends Area3D


enum Sides {LEFT, RIGHT}


var inspecting : bool = false
var digits : Array[int] = [0, 0, 0, 0]
var code_complete : bool = false


func _ready() -> void:
	Global.puzderko = self

	for node : Node in get_tree().get_nodes_in_group("Digits"):
		var idx_str : String = String(node.name)[5]
		var idx : int = idx_str.to_int() - 1
		var side : Sides = Sides.LEFT if node.name.ends_with("Left") else Sides.RIGHT
		node.pressed.connect(update_digit.bind(idx, side))
		print("connected %s with bindings %s %s" % [node.name, idx, side])


func _mouse_enter() -> void:
	if not Global.item_in_hand == null or inspecting:
		return

	Input.set_custom_mouse_cursor(Inspectable.CURSOR_MAGNIFYING_GLASS, Input.CURSOR_ARROW, Vector2(16, 16))


func _mouse_exit() -> void:
	if not Global.item_in_hand == null:
		return

	Input.set_custom_mouse_cursor(null)


func _input_event(_camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if inspecting:
			return

		inspecting = true
		$Camera3D.make_current()
		$PadlockUI.show()


func unlock() -> void:
	%padlock_lock.position.y += 0.005
	$PadlockUI.hide()
	code_complete = true


func update_digit(index: int, side: Sides) -> void:
	digits[index] = digits[index] + 1 if side == Sides.LEFT else digits[index] - 1
	digits[index] = wrapi(digits[index], 0, 10)
	match index:
		0:
			if side == Sides.LEFT:
				%code_1.rotate_y(deg_to_rad(-36))
			else:
				%code_1.rotate_y(deg_to_rad(36))
		1:
			if side == Sides.LEFT:
				%code_2.rotate_y(deg_to_rad(-36))
			else:
				%code_2.rotate_y(deg_to_rad(36))
		2:
			if side == Sides.LEFT:
				%code_3.rotate_y(deg_to_rad(-36))
			else:
				%code_3.rotate_y(deg_to_rad(36))
		3:
			if side == Sides.LEFT:
				%code_4.rotate_y(deg_to_rad(-36))
			else:
				%code_4.rotate_y(deg_to_rad(36))

	if digits == [1, 3, 3, 7]:
		unlock()
