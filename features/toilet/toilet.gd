extends Interactable


@export var key_anim : AnimationPlayer


func _ready() -> void:
	assert(key_anim is AnimationPlayer, "AnimationPlayer not assigned for %s" % get_path())


func interact() -> void:
	key_anim.play("Drop")
	set_script(null)
	SignalBus.change_cursor.emit(null)
