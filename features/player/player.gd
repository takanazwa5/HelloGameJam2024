class_name Player extends CharacterBody3D


const SPEED : float = 1.0
const ACCELERATION : float = 1.0
const DECELERATION : float = 0.25


var speed : float = SPEED


func _physics_process(delta: float) -> void:
	update_gravity(delta)
	update_input(delta)
	move_and_slide()


func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func update_input(_delta: float) -> void:
	var input_dir : Vector2 = Input.get_vector("walk_up", "walk_down", "walk_right", "walk_left")

	if input_dir:
		velocity.x = lerpf(velocity.x, input_dir.x * speed, ACCELERATION)
		velocity.z = lerpf(velocity.z, input_dir.y * speed, ACCELERATION)

	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)
