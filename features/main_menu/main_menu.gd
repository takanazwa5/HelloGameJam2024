class_name MainMenu extends CanvasLayer


@onready var buttons_container : VBoxContainer = %ButtonsContainer
@onready var start_game_button : Button = %StartGameButton
@onready var settings_button : Button = %SettingsButton
@onready var quit_button : Button = %QuitButton
@onready var settings_menu : SettingsMenu = %SettingsMenu


func _ready() -> void:

	start_game_button.pressed.connect(_on_start_game_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	settings_menu.visibility_changed.connect(_on_settings_menu_visibility_changed)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_start_game_button_pressed() -> void:

	var main_scene : PackedScene = load("res://scenes/main/main.tscn")
	get_tree().change_scene_to_packed(main_scene)


func _on_settings_button_pressed() -> void:

	settings_menu.show()


func _on_quit_button_pressed() -> void:

	get_tree().quit()


func _on_settings_menu_visibility_changed() -> void:

	buttons_container.visible = not settings_menu.visible
