extends Interactable


func interact() -> void:
	%OmniLight3D.visible = true if not %OmniLight3D.visible else false
