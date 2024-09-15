class_name MainMenu extends Control


func _ready() -> void:
	%StartGameButton.pressed.connect(on_start_game_button_pressed)
	%SettingsButton.pressed.connect(on_settings_button_pressed)
	%QuitButton.pressed.connect(get_tree().quit)


func on_start_game_button_pressed() -> void:
	pass


func on_settings_button_pressed() -> void:
	pass
