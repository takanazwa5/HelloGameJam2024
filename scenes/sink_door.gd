class_name SinkDoor extends Interactable


var original_rotation : Vector3 = rotation


func _ready() -> void:
	super()

	Global.sink_door = self
	Global.sink_camera = cam


func interact() -> void:
	can_interact = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", rotation + Vector3(0.0, deg_to_rad(90.0), 0.0), 0.5)


func reset() -> void:
	rotation = original_rotation
	can_interact = true
