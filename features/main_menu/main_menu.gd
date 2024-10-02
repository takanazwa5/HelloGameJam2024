class_name MainMenu extends Control


const MAIN : PackedScene = preload("res://scenes/main/main.tscn")


func _ready() -> void:
	%StartGameButton.pressed.connect(get_tree().change_scene_to_packed.bind(MAIN))
	%SettingsButton.pressed.connect(%SettingsMenu.show)
	%QuitButton.pressed.connect(get_tree().quit)

	%SettingsMenu.visibility_changed.connect(on_settings_menu_visibility_changed)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func on_settings_menu_visibility_changed() -> void:
	%Panel.visible = not %SettingsMenu.visible
