class_name Openable extends Interactable


@export var animation_player : AnimationPlayer
@export var locked : bool = false


var opened : bool = false


func _ready() -> void:
	super()

	assert(animation_player is AnimationPlayer, "AnimationPlayer not set for %s" % get_path())

	SignalBus.back_button_pressed.connect(_on_back_button_pressed)


func interact() -> void:
	if locked:
		SignalBus.create_dialog.emit("It's locked.")
		return

	if animation_player.is_playing():
		return

	if not opened:
		animation_player.play("Open")
		opened = true
	else:
		animation_player.play_backwards("Open")
		opened = false


func _on_back_button_pressed() -> void:
	await SignalBus.camera_changed
	animation_player.play("RESET")
	opened = false
