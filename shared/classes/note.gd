class_name Note extends Interactable


@export var target_pos : Vector3 = Vector3.ZERO
@export var target_rot : Vector3 = Vector3.ZERO


var original_transform : Transform3D


func _ready() -> void:
	super()

	assert(not target_pos == Vector3.ZERO, "Target pos not set for %s" % get_path())
	assert(not target_rot == Vector3.ZERO, "Target rot not set for %s" % get_path())

	original_transform = transform


func interact() -> void:
	SignalBus.note_inspection.emit(self)
	position = target_pos
	rotation_degrees = target_rot
	input_ray_pickable = false


func reset() -> void:
	transform = original_transform
	input_ray_pickable = true
