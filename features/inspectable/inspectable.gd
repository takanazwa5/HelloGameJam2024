@icon("res://features/inspectable/inspectable.svg")
class_name Inspectable extends CollisionObject3D


const MAGNIFYING_GLASS_ICON : Texture2D = preload("res://shared/icons/magnifying_glass_icon.png")


@export var camera : Camera3D
@export var outline : Node3D


var waiting_for_player : bool = false


func _ready() -> void:
	assert(camera is Camera3D, "Camera not assigned for %s" % get_path())
	assert(outline is Node3D, "Outline not assigned for %s" % get_path())

	SignalBus.freeroaming_started.connect(_on_freeroaming_started)
	SignalBus.navigation_to_inspectable_finished.connect(_on_navigation_to_inspectable_finished)
	SignalBus.back_button_pressed.connect(_on_back_button_pressed)
	SignalBus.inspectable_clicked.connect(_on_inspectable_clicked)
	SignalBus.bathroom_door_interaction.connect(_on_bathroom_door_interaction)
	SignalBus.door_clicked.connect(_on_door_clicked)


func _mouse_enter() -> void:
	SignalBus.change_cursor.emit(MAGNIFYING_GLASS_ICON)
	outline.show()


func _mouse_exit() -> void:
	SignalBus.change_cursor.emit(null)
	outline.hide()


func _input_event(_p_camera: Camera3D, p_event: InputEvent, \
_p_event_position: Vector3, _p_normal: Vector3, _p_shape_idx: int) -> void:

	if p_event is InputEventMouseButton \
	and p_event.button_index == MOUSE_BUTTON_LEFT \
	and p_event.pressed:

		SignalBus.inspectable_clicked.emit(self)


func _on_navigation_to_inspectable_finished() -> void:
	if waiting_for_player:
		_inspect()
	waiting_for_player = false
	_disable()


func _on_freeroaming_started() -> void:
	waiting_for_player = false


func _on_back_button_pressed() -> void:
	await SignalBus.camera_changed
	input_ray_pickable = true


func _on_inspectable_clicked(p_inspectable: Inspectable) -> void:
	waiting_for_player = p_inspectable == self


func _disable() -> void:
	input_ray_pickable = false
	outline.hide()


func _inspect() -> void:
	_disable()
	SignalBus.change_camera.emit(camera)


func _on_bathroom_door_interaction() -> void:
	_disable()
	await SignalBus.camera_changed
	input_ray_pickable = true


func _on_door_clicked(_p_door: Door) -> void:
	waiting_for_player = false
