class_name Player extends CharacterBody3D


const SPEED : float = 1.0
const ACCELERATION : float = 1.0
const DECELERATION : float = 0.25


var input_dir : Vector2 = Vector2.ZERO
var speed : float = SPEED
var click_pos : Vector2 = Vector2.ZERO


func _ready() -> void:
	SignalBus.ground_click.connect(on_ground_click)


func _physics_process(delta: float) -> void:
	update_gravity(delta)
	update_input(delta)
	move_and_slide()


func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func update_input(_delta: float) -> void:
	#input_dir = Input.get_vector("walk_up", "walk_down", "walk_right", "walk_left").normalized()

	if input_dir:
		velocity.x = lerpf(velocity.x, input_dir.x * speed, ACCELERATION)
		velocity.z = lerpf(velocity.z, input_dir.y * speed, ACCELERATION)
		var pos : Vector2 = Vector2(global_position.x, global_position.z)
		var distance_to_click : float = pos.distance_to(click_pos)
		if distance_to_click < 0.01:
			input_dir = Vector2.ZERO


	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)


func on_ground_click(pos: Vector3) -> void:
	click_pos = Vector2(pos.x, pos.z)
	var direction : Vector3 = pos - global_position
	input_dir = Vector2(direction.x, direction.z).normalized()
