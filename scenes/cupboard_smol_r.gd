class_name CupboardSmolR extends Interactable


var original_rotation : Vector3 = rotation
var open : bool = false


func _ready() -> void:
	super()

	Global.cupboard_smol_r = self
	Global.cupboard_smol_camera = cam


func interact() -> void:
	if open:
		return

	var tween : Tween = get_tree().create_tween()
	open = true
	tween.tween_property(self, "rotation", rotation + Vector3(0.0, deg_to_rad(120.0), 0.0), 0.5)


func reset() -> void:
	rotation = original_rotation
	open = false
