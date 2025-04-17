class_name Player extends CharacterBody3D


const SPEED : float = 1.0
const ACCELERATION : float = 0.5
const DECELERATION : float = 0.1


var navigating : bool = false


func _ready() -> void:

	pass


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

	pass
