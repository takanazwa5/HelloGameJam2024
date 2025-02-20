class_name MainMenu extends Control


@onready var _buttons_container : VBoxContainer = %ButtonsContainer
@onready var _start_game_button : Button = %StartGameButton
@onready var _settings_button : Button = %SettingsButton
@onready var _quit_button : Button = %QuitButton
@onready var _settings_menu : SettingsMenu = %SettingsMenu


func _ready() -> void:

	_start_game_button.pressed.connect(_on_start_game_button_pressed)
	_settings_button.pressed.connect(_on_settings_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)
	_settings_menu.visibility_changed.connect(_on_settings_menu_visibility_changed)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_start_game_button_pressed() -> void:

	var main_scene : PackedScene = load("res://scenes/main/main.tscn")
	get_tree().change_scene_to_packed(main_scene)


func _on_settings_button_pressed() -> void:

	_settings_menu.show()


func _on_quit_button_pressed() -> void:

	get_tree().quit()


func _on_settings_menu_visibility_changed() -> void:

	_buttons_container.visible = not _settings_menu.visible
