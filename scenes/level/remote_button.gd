extends Interactable


func _ready() -> void:
	super()

	assert(name.is_valid_int(), "Remote button name is not valid int")


func interact() -> void:
	SignalBus.remote_button_pressed.emit(name.to_int())
