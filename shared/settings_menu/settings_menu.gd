class_name SettingsMenu extends Control


const SETTINGS_KEYBIND : PackedScene = preload("res://shared/settings_menu/settings_keybind/settings_keybind.tscn")


var master_audio_bus_index : int = AudioServer.get_bus_index("Master")


func _ready() -> void:
	# Categories
	%GameButton.pressed.connect(on_game_button_pressed)
	%VideoButton.pressed.connect(on_video_button_pressed)
	%AudioButton.pressed.connect(on_audio_button_pressed)
	%KeyboardButton.pressed.connect(on_keyboard_button_pressed)

	# Game
	%MouseSensitivity.value_changed.connect(on_mouse_sensitivity_value_changed)

	# Video
	%WindowMode.value_changed.connect(on_window_mode_value_changed)
	%FramerateLimit.value_changed.connect(on_framerate_limit_value_changed)
	%VSync.value_changed.connect(on_vsync_value_changed)
	%Brightness.value_changed.connect(on_brightness_value_changed)
	%MSAA.value_changed.connect(on_msaa_value_changed)
	%FSR.value_changed.connect(on_fsr_value_changed)

	# Audio
	%MasterVolume.value_changed.connect(on_master_volume_value_changed)

	hide()
	on_game_button_pressed()
	instantiate_keybinds_buttons()
	check_connections()
	apply_default_values()


#-------------------------------------------------------------------------------
#
# Categories buttons
#
#-------------------------------------------------------------------------------


func on_game_button_pressed() -> void:
	hide_categories()
	%Game.show()
	%GameButton/Border.show()


func on_video_button_pressed() -> void:
	hide_categories()
	%Video.show()
	%VideoButton/Border.show()


func on_audio_button_pressed() -> void:
	hide_categories()
	%Audio.show()
	%AudioButton/Border.show()


func on_keyboard_button_pressed() -> void:
	hide_categories()
	%Keyboard.show()
	%KeyboardButton/Border.show()


func hide_categories() -> void:
	%Game.hide()
	%GameButton/Border.hide()
	%Video.hide()
	%VideoButton/Border.hide()
	%Audio.hide()
	%AudioButton/Border.hide()
	%Keyboard.hide()
	%KeyboardButton/Border.hide()


#-------------------------------------------------------------------------------
#
# Game settings
#
#-------------------------------------------------------------------------------


func on_mouse_sensitivity_value_changed(_value: float) -> void:
	pass


#-------------------------------------------------------------------------------
#
# Video settings
#
#-------------------------------------------------------------------------------


func on_window_mode_value_changed(value: int) -> void:
	match value:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func on_framerate_limit_value_changed(value: int) -> void:
	match value:
		0:
			Engine.set_max_fps(30)
		1:
			Engine.set_max_fps(60)
		2:
			Engine.set_max_fps(120)
		3:
			Engine.set_max_fps(144)
		4:
			Engine.set_max_fps(240)
		5:
			Engine.set_max_fps(0)


func on_vsync_value_changed(value: bool) -> void:
	match value:
		true:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		false:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func on_brightness_value_changed(_value: float) -> void:
	pass


func on_msaa_value_changed(value: int) -> void:
	get_viewport().set_msaa_3d(value)


func on_fsr_value_changed(value: int) -> void:
	var viewport : Viewport = get_viewport()

	if value == 0:
		viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
		viewport.set_scaling_3d_scale(1.0)
		return

	viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)

	match value:
		1:
			viewport.set_scaling_3d_scale(0.5)
		2:
			viewport.set_scaling_3d_scale(0.59)
		3:
			viewport.set_scaling_3d_scale(0.67)
		4:
			viewport.set_scaling_3d_scale(0.77)


#-------------------------------------------------------------------------------
#
# Audio settings
#
#-------------------------------------------------------------------------------


func on_master_volume_value_changed(value: float) -> void:
	var master_audio_bus_volume_db : float = linear_to_db(value)
	AudioServer.set_bus_volume_db(master_audio_bus_index, master_audio_bus_volume_db)


#-------------------------------------------------------------------------------
#
# Keyboard settings
#
#-------------------------------------------------------------------------------


func instantiate_keybinds_buttons() -> void:
	InputMap.load_from_project_settings()

	for action : StringName in InputMap.get_actions():

		if action.begins_with("ui") or action == action.to_upper():
			continue

		var button : Node = SETTINGS_KEYBIND.instantiate()
		var action_label : Label = button.find_child("Action")
		var event_button : Button = button.find_child("Event")

		button.action = action

		action_label.text = action.replace("_", " ").capitalize()
		var events : Array[InputEvent] = InputMap.action_get_events(action)
		if events.size() > 0:
			event_button.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			event_button.text = "Unassigned"

		%Keyboard/VBoxContainer.add_child(button)


#-------------------------------------------------------------------------------
#
# Other
#
#-------------------------------------------------------------------------------


func check_connections() -> void:
	for node : Node in %Game/VBoxContainer.get_children():
		if node.value_changed.get_connections().is_empty():
			push_warning("%s.value_changed is not connected." % node.name)

	for node : Node in %Video/VBoxContainer.get_children():
		if node.value_changed.get_connections().is_empty():
			push_warning("%s.value_changed is not connected." % node.name)

	for node : Node in %Audio/VBoxContainer.get_children():
		if node.value_changed.get_connections().is_empty():
			push_warning("%s.value_changed is not connected." % node.name)


func apply_default_values() -> void:
	pass
