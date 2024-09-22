class_name MainMenu extends Control


const MAIN : PackedScene = preload("res://scenes/main/main.tscn")


func _ready() -> void:
	%StartGameButton.pressed.connect(on_start_game_button_pressed)
	%SettingsButton.pressed.connect(%SettingsMenu.show)
	%QuitButton.pressed.connect(get_tree().quit)

	%SettingsMenu.visibility_changed.connect(on_settings_menu_visibility_changed)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_ESCAPE:
			%SettingsMenu.hide()


func on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)


func on_settings_menu_visibility_changed() -> void:
	%ButtonsContainer.visible = not %SettingsMenu.visible
