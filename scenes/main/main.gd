class_name Main extends Node


var last_camera : Camera3D


func _ready() -> void:
	DebugConsole.create_command("tp_broom", player_tp_broom, "Teleport player to bathroom")
	DebugConsole.create_command("tp_lroom", player_tp_lroom, "Teleport player to living room")

	%BackButton.pressed.connect(_on_back_button_pressed)
	%DialogTimer.timeout.connect(_on_dialog_timer_timeout)
	SignalBus.change_camera.connect(_change_camera)
	SignalBus.navigation_to_inspectable_finished.connect(_on_navigation_to_inspectable_finished)
	SignalBus.unstuck_button_pressed.connect(_on_unstuck_button_pressed)
	SignalBus.create_dialog.connect(_on_create_dialog)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:

		if event.button_index == MOUSE_BUTTON_LEFT:
			#print(_shoot_ray())
			pass


func _process(_delta: float) -> void:
	DebugPanel.add_property("FPS", Engine.get_frames_per_second(), 1)


func _shoot_ray() -> CollisionObject3D:
	var viewport : Viewport = get_viewport()
	var camera : Camera3D = viewport.get_camera_3d()
	var mouse_pos : Vector2 = viewport.get_mouse_position()
	var world : World3D = camera.get_world_3d()
	var space_state : PhysicsDirectSpaceState3D = world.get_direct_space_state()
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	query.from = camera.global_position
	query.to = camera.project_ray_normal(mouse_pos) * 100
	var result : Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		return null
	else:
		return result.collider


func player_tp_broom() -> String:
	%Player.position = %BathroomSpawnPoint.position
	%BathroomCamera.make_current()
	return "Player teleported to bathroom"


func player_tp_lroom() -> String:
	%Player.position = %LivingRoomSpawnPoint.position
	%LivingRoomCamera.make_current()
	return "Player teleported to living room"


func _on_navigation_to_inspectable_finished() -> void:
	await SignalBus.camera_changed
	%BackButton.show()


func _on_back_button_pressed() -> void:
	SignalBus.back_button_pressed.emit()
	%BackButton.hide()
	_change_camera(last_camera)


func _change_camera(p_camera: Camera3D) -> void:
	%Black.show()
	%Black/Animations.play("BlackFadeIn")
	await %Black/Animations.animation_finished

	last_camera = get_viewport().get_camera_3d()
	p_camera.make_current()
	SignalBus.camera_changed.emit(last_camera, p_camera)

	%Black/Animations.play_backwards("BlackFadeIn")
	await %Black/Animations.animation_finished
	%Black.hide()


func _on_unstuck_button_pressed() -> void:
	if %LivingRoomCamera.current:
		%Player.position = %LivingRoomUnstuckSpawnPoint.position
	elif %BathroomCamera.current:
		%Player.position = %LivingRoomUnstuckSpawnPoint.position
	%Player.stop_navigating()


func _on_create_dialog(p_text: String) -> void:
	%Dialog.text = p_text
	%Dialog.show()
	%DialogTimer.wait_time = p_text.length() / 10.0
	%DialogTimer.start()


func _on_dialog_timer_timeout() -> void:
	%Dialog.hide()
