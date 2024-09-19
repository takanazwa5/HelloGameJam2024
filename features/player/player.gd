class_name Player extends CharacterBody3D


const SPEED : float = 1.0
const ACCELERATION : float = 0.5
const DECELERATION : float = 0.1


var input_dir : Vector2 = Vector2.ZERO
var click_pos : Vector2 = Vector2.ZERO
var inspecting : bool = false
var moving_to_inspectable : bool = false
var freeroaming : bool = false
var movement_disabled : bool = true
var blend_pos_remapped : float = 0.0


@onready var animations : AnimationPlayer = $Character.get_node("%Animations")
@onready var animation_tree : AnimationTree = $Character.get_node("%AnimationTree")


func _ready() -> void:
	Global.player = self

	animations.animation_finished.connect(on_animation_finished)

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta: float) -> void:
	update_gravity(delta)
	update_input(delta)
	move_and_slide()


func _process(_delta: float) -> void:
	DebugPanel.add_property("global_pos", global_position, 0)

	animation_tree.set("parameters/blend_position", velocity.length())


func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func update_input(delta: float) -> void:
	if input_dir:
		velocity.x = lerpf(velocity.x, input_dir.x * SPEED, ACCELERATION)
		velocity.z = lerpf(velocity.z, input_dir.y * SPEED, ACCELERATION)

		if freeroaming:
			var pos : Vector2 = Vector2(global_position.x, global_position.z)
			var distance_to_click : float = pos.distance_to(click_pos)
			if distance_to_click < 0.01:
				input_dir = Vector2.ZERO
				freeroaming = false

		var left_axis : Vector3 = Vector3.UP.cross(Vector3(input_dir.x, 0.0, input_dir.y))
		var rotation_basis : Quaternion = Basis(left_axis, Vector3.DOWN, \
		Vector3(input_dir.x, 0.0, input_dir.y)).get_rotation_quaternion()
		var model_scale : Vector3 = $Character.basis.get_scale()
		$Character.basis = Basis($Character.basis.get_rotation_quaternion().slerp( \
		rotation_basis, delta * 10.0)).scaled(model_scale)


	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)


func move_to_position(pos: Vector3) -> void:
	if movement_disabled:
		return

	click_pos = Vector2(pos.x, pos.z)
	var direction : Vector3 = pos - global_position
	input_dir = Vector2(direction.x, direction.z).normalized()


func on_animation_finished(anim_name: StringName) -> void:
	if not anim_name == &"Waking up":
		return

	animation_tree.active = true
	animations.active = false
