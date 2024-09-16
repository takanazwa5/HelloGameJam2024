class_name TestInteractable extends Interactable


func correct_item_used() -> void:
	$MeshInstance3D.material_override.albedo_color = Color.RED
