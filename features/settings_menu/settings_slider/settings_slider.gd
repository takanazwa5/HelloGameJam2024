@tool
class_name SettingsSlider extends PanelContainer


signal value_changed(value: float)


@export var text : String = "Label":
	set(val):
		text = val
		%LeftLabel.text = val

@export var min_value : float = 0.0:
	set(val):
		min_value = val
		%Slider.min_value = val

@export var max_value : float = 100.0:
	set(val):
		max_value = val
		%Slider.max_value = val

@export var step : float = 1.0:
	set(val):
		step = val
		%Slider.step = val

@export var default : float:
	set(val):
		val = clampf(snappedf(val, 0.01), min_value, max_value)
		default = val
		value = val


var value : float = 0.0:
	set(val):
		value = val
		%Slider.set_value_no_signal(val)
		%RightLabel.text = str(value)
		value_changed.emit(val)


func _ready() -> void:
	%Slider.value_changed.connect(on_slider_value_changed)
	%RightLabel.text = str(snappedf(%Slider.value, step))


func on_slider_value_changed(val: float) -> void:
	val = snappedf(val, 0.01)
	value = val
