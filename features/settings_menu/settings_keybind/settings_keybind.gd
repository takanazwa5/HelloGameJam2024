class_name SettingsKeybind extends PanelContainer


var remapping : bool = false
var action : StringName = &""


func _ready() -> void:
	%Event.pressed.connect(on_event_button_pressed)


func _input(event: InputEvent) -> void:
	if not remapping:
		return

	if event is InputEventMouseButton and event.is_double_click():
		event.double_click = false

	elif event is InputEventKey:

		if event.pressed and event.physical_keycode == KEY_ESCAPE:
			remapping = false
			var previous_event : InputEvent = InputMap.action_get_events(action)[0]
			var previous_event_string : String = previous_event.as_text().trim_suffix(" (Physical)")
			%Event.text = previous_event_string
			accept_event()
			return

		elif event.pressed and event.physical_keycode == KEY_BACKSPACE:
			remapping = false
			InputMap.action_erase_events(action)
			%Event.text = "Unassigned"
			return

	if event is InputEventKey or event is InputEventMouseButton:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		var input_event : InputEvent = InputMap.action_get_events(action)[0]
		var event_text : String = input_event.as_text().trim_suffix(" (Physical)")
		%Event.text = event_text
		remapping = false
		accept_event()


func on_event_button_pressed() -> void:
	%Event.text = "..."
	remapping = true
