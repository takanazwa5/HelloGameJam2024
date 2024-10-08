class_name Player extends CharacterBody3D


const SPEED : float = 1.0
const ACCELERATION : float = 0.5
const DECELERATION : float = 0.1


var navigating : bool = false
var freeroaming : bool = true
var navigating_to_inspectable : bool = false
var navigating_to_door : bool = false
var room : Level.Room = Level.Room.LIVING_ROOM


@onready var animations : AnimationPlayer = $Character.get_node("%Animations")
@onready var animation_tree : AnimationTree = $Character.get_node("%AnimationTree")


func _ready() -> void:
	animations.animation_finished.connect(_on_animation_finished)
	%NavAgent.navigation_finished.connect(_on_navigation_finished)
	SignalBus.floor_click.connect(_on_floor_click)
	SignalBus.inspectable_clicked.connect(_on_inspectable_clicked)
	SignalBus.door_clicked.connect(_on_door_clicked)

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	_on_animation_finished(&"Waking up") # NOTE: TEMP


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction : Vector3 = Vector3.ZERO

	if navigating:
		var new_direction : Vector3 = %NavAgent.get_next_path_position() - global_position
		direction = Vector3(new_direction.x, 0, new_direction.z).normalized()

	if direction:
		velocity.x = lerpf(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.z = lerpf(velocity.z, direction.z * SPEED, ACCELERATION)

		var left_axis : Vector3 = Vector3.UP.cross(direction)
		var rotation_basis : Quaternion = Basis(left_axis, Vector3.UP, \
		direction).get_rotation_quaternion()
		var model_scale : Vector3 = $Character.basis.get_scale()
		$Character.basis = Basis($Character.basis.get_rotation_quaternion().slerp( \
		rotation_basis, delta * 10.0)).scaled(model_scale)

	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()


func _process(_delta: float) -> void:
	animation_tree.set("parameters/blend_position", velocity.length())

	DebugPanel.add_property("Navigating", navigating, 2)
	DebugPanel.add_property("Freeroaming", freeroaming, 3)


func stop_navigating() -> void:
	DebugConsole.print_line("navigation finished")
	navigating = false


func _on_animation_finished(p_anim_name: StringName) -> void:
	match p_anim_name:

		&"Waking up":
			animation_tree.active = true
			animations.active = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _navigate_to(p_pos: Vector3) -> void:
	%NavAgent.target_position = p_pos
	if not navigating:
		DebugConsole.print_line("navigation started with target %s" % p_pos)
	else:
		DebugConsole.print_line("navigation target changed to %s" % p_pos)
	navigating = true


func _on_floor_click(p_pos: Vector3) -> void:
	_navigate_to(p_pos)
	freeroaming = true
	navigating_to_inspectable = false
	navigating_to_door = false
	SignalBus.freeroaming_started.emit()


func _on_navigation_finished() -> void:
	stop_navigating()

	if freeroaming:
		return

	if navigating_to_inspectable:
		SignalBus.navigation_to_inspectable_finished.emit()
		navigating_to_inspectable = false

	elif navigating_to_door:
		SignalBus.navigation_to_door_finished.emit()
		navigating_to_door = false


func _on_inspectable_clicked(p_inspectable: Inspectable) -> void:
	_navigate_to(p_inspectable.global_position)
	navigating_to_inspectable = true
	navigating_to_door = false
	freeroaming = false


func _on_door_clicked(p_door: Door) -> void:
	_navigate_to(p_door.global_position)
	navigating_to_door = true
	navigating_to_inspectable = false
	freeroaming = false
