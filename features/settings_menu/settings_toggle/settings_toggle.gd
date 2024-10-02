@tool
class_name SettingsToggle extends PanelContainer


signal value_changed(value: bool)


@export var text : String = "Label":
	set(val):
		text = val
		%LeftLabel.text = val


var value : bool = false:
	set(val):
		value = val
		if val:
			%OnButton/Border.show()
			%OffButton/Border.hide()
			value_changed.emit(true)
		else:
			%OffButton/Border.show()
			%OnButton/Border.hide()
			value_changed.emit(false)


func _ready() -> void:
	%OnButton.pressed.connect(on_on_button_pressed)
	%OffButton.pressed.connect(on_off_button_pressed)


func on_on_button_pressed() -> void:
	value = true

func on_off_button_pressed() -> void:
	value = false
