class_name Flush extends Interactable


func interact() -> void:
	%key_shelf.show()
	%KeyDrop.play()
	can_interact = false
