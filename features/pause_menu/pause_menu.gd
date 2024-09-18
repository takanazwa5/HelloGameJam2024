class_name PauseMenu extends Control


var previous_mouse_mode : int


func _ready() -> void:
	%ResumeButton.pressed.connect(toggle_pause)
	%SettingsButton.pressed.connect(on_settings_button_pressed)
	%UnstuckButton.pressed.connect(on_unstuck_button_pressed)
	%DebugPanelButton.pressed.connect(on_debug_panel_button_pressed)
	%QuitButton.pressed.connect(get_tree().quit)

	hide()
	%MainPauseContainer.show()
	DebugPanel.show()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_ESCAPE:

			if %SettingsMenu.visible:
				%SettingsMenu.hide()
				%MainPauseContainer.show()

			else:
				toggle_pause()


func toggle_pause() -> void:
	if not get_tree().is_paused():
		get_tree().set_pause(true)
		show()
		previous_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	else:
		get_tree().set_pause(false)
		hide()
		Input.set_mouse_mode(previous_mouse_mode)


func on_settings_button_pressed() -> void:
	%MainPauseContainer.hide()
	%SettingsMenu.show()


func on_unstuck_button_pressed() -> void:
	if Global.main_camera.is_current():
		Global.player.global_position = Global.living_room_unstuck_spawn_point
		Global.player.input_dir = Vector2.ZERO

	elif Global.bathroom_camera.is_current():
		Global.player.global_position = Global.bathroom_unstuck_spawn_point
		Global.player.input_dir = Vector2.ZERO


func on_debug_panel_button_pressed() -> void:
	if DebugPanel.visible:
		DebugPanel.visible = false
		%DebugPanelButton.text = "DebugPanel: OFF"

	else:
		DebugPanel.visible = true
		%DebugPanelButton.text = "DebugPanel: ON"
