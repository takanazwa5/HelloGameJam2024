class_name Drawer extends Interactable


@export var animation_player : AnimationPlayer


var opened : bool = false


func _ready() -> void:
	super()

	assert(animation_player is AnimationPlayer, "AnimationPlayer not set for %s" % get_path())


func _interact() -> void:
	if animation_player.is_playing():
		return

	if not opened:
		animation_player.play("Open")
		opened = true
	else:
		animation_player.play_backwards("Open")
		opened = false
