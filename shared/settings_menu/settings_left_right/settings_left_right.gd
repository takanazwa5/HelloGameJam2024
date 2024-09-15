@tool
class_name SettingsLeftRight extends PanelContainer


signal value_changed(value: int)


enum ButtonSide {
	LEFT,
	RIGHT,
}


@export var left_text : String = "Left text":
	set(val):
		left_text = val
		%LeftLabel.text = val

@export var options : Array[String] = []

@export var default : int = 0:
	set(val):
		if options.size() < 2:
			return
		if val < 0:
			default = 0
			right_text = options[0]
		elif val > options.size() - 1:
			default = options.size() - 1
			right_text = options[-1]
		else:
			default = val
			right_text = options[val]


var right_text : String = "":
	set(val):
		right_text = val
		%RightLabel.text = val


var value : int = 0:
	set(val):
		value = val
		right_text = options[val]
		value_changed.emit(val)


func _ready() -> void:
	if options.size() < 2:
		push_error("Options arr size < 2")

	right_text = options[default]

	%LeftButton.pressed.connect(on_button_pressed.bind(ButtonSide.LEFT))
	%RightButton.pressed.connect(on_button_pressed.bind(ButtonSide.RIGHT))


func on_button_pressed(side: ButtonSide) -> void:
	if options.is_empty():
		return

	var index : int = options.find(right_text)

	if index == -1:
		push_error("Option index not found")
		return

	var new_index : int = index

	match side:
		ButtonSide.LEFT:
			new_index = wrapi(index - 1, 0, options.size())
		ButtonSide.RIGHT:
			new_index = wrapi(index + 1, 0, options.size())

	value = new_index
