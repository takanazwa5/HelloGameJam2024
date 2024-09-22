class_name ExitDoor extends Door


func _ready() -> void:
	super()

	Global.exit_door = self

	DebugConsole.create_command("exit_get_key", func() -> void: has_key = true)


func interact() -> void:
	Global.player.movement_disabled = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Global.main.get_node("%Animations").play("BlackFadeIn")
	await Global.main.get_node("%Animations").animation_finished
	get_tree().change_scene_to_packed(load("res://scenes/end_game.tscn"))
