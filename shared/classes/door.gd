@icon("res://shared/classes/door.svg")
class_name Door extends CollisionObject3D


const DOOR_ICON = preload("res://shared/icons/door_icon.png")
const KEY_ICON = preload("res://shared/icons/key_icon.png")


@export var has_key : bool = true
@export_multiline var no_key_dialog : String = ""
@export var outline : Node3D


var waiting_for_player : bool = false


func _ready() -> void:
	SignalBus.navigation_to_door_finished.connect(_on_navigation_to_door_finished)
	SignalBus.freeroaming_started.connect(_on_freeroaming_started)
	SignalBus.navigation_to_inspectable_finished.connect(_on_navigation_to_inspectable_finished)
	SignalBus.back_button_pressed.connect(_on_back_button_pressed)
	SignalBus.inspectable_clicked.connect(_on_inspectable_clicked)

	assert(outline is Node3D, "Outline not assigned for %s" % get_path())


func _mouse_enter() -> void:
	SignalBus.change_cursor.emit(DOOR_ICON if has_key else KEY_ICON)
	outline.show()


func _mouse_exit() -> void:
	SignalBus.change_cursor.emit(null)
	outline.hide()


func _input_event(_camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		waiting_for_player = true
		SignalBus.door_clicked.emit(self)


func _on_navigation_to_door_finished() -> void:
	if not waiting_for_player:
		return

	waiting_for_player = false
	if not has_key:
		SignalBus.create_dialog.emit(no_key_dialog)
		return

	_interact()


func _interact() -> void:
	print_debug("interact not overriden")


func _on_freeroaming_started() -> void:
	waiting_for_player = false


func _on_navigation_to_inspectable_finished() -> void:
	input_ray_pickable = false


func _on_back_button_pressed() -> void:
	await SignalBus.camera_changed
	input_ray_pickable = true


func _on_inspectable_clicked(_p_inspectable: Inspectable) -> void:
	waiting_for_player = false
