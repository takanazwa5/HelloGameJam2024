class_name Fridge extends Node3D


@export var cam : Camera3D


var door_down_open : bool = false
var door_up_open : bool = false


func _ready() -> void:
	assert(cam is Camera3D, "Camera not assigned for %s" % get_path())

	%FridgeDoorDown.mouse_entered.connect(on_mouse_entered)
	%FridgeDoorDown.mouse_exited.connect(on_mouse_exited)
	%FridgeDoorDown.input_event.connect(on_fridge_door_down_input_event)
	%FridgeDoorUp.mouse_entered.connect(on_mouse_entered)
	%FridgeDoorUp.mouse_exited.connect(on_mouse_exited)
	%FridgeDoorUp.input_event.connect(on_fridge_door_up_input_event)

	Global.fridge = self
	Global.fridge_camera = cam

func on_mouse_entered() -> void:
	if cam.is_current():
		Input.set_custom_mouse_cursor(Item.CURSOR_HAND, Input.CURSOR_ARROW, Vector2(16, 16))


func on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func on_fridge_door_down_input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if not door_down_open:
			door_down_open = true
			%DoorDownAnimations.play("DoorDownOpen")


func on_fridge_door_up_input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if not door_up_open:
			door_up_open = true
			%DoorUpAnimations.play("DoorUpOpen")


func reset() -> void:
	door_down_open = false
	door_up_open = false
	%DoorDownAnimations.play("RESET")
	%DoorUpAnimations.play("RESET")
