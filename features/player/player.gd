class_name Player extends CharacterBody3D


const SPEED : float = 1.0
const ACCELERATION : float = 1.0
const DECELERATION : float = 0.25


var input_dir : Vector2 = Vector2.ZERO
var click_pos : Vector2 = Vector2.ZERO
var inspecting : bool = false
var moving_to_inspectable : bool = false
var freeroaming : bool = false
var movement_disabled : bool = true


@onready var animations : AnimationPlayer = $Character.get_node("%Animations")


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


func update_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func update_input(_delta: float) -> void:
	if input_dir:
		velocity.x = lerpf(velocity.x, input_dir.x * SPEED, ACCELERATION)
		velocity.z = lerpf(velocity.z, input_dir.y * SPEED, ACCELERATION)

		if freeroaming:
			var pos : Vector2 = Vector2(global_position.x, global_position.z)
			var distance_to_click : float = pos.distance_to(click_pos)
			if distance_to_click < 0.01:
				input_dir = Vector2.ZERO
				freeroaming = false

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

	movement_disabled = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
