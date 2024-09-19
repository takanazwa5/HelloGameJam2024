class_name RemoteButton extends Interactable


func interact() -> void:
	Global.tv.button_pressed(get_parent().name.trim_prefix("button").to_int())
