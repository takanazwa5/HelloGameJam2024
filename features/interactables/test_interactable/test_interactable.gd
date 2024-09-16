class_name TestInteractable extends InteractableWithItem


func correct_item_used() -> void:
	$MeshInstance3D.material_override.albedo_color = Color.RED
