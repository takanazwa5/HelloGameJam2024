class_name Main extends Node


func _ready() -> void:
	Global.main = self
	Global.main_camera = %MainCamera
	Global.bathroom_camera = %BathroomCamera
	Global.living_room_unstuck_spawn_point = %LivingRoomUnstuckSpawnPoint.global_position
	Global.bathroom_unstuck_spawn_point = %BathroomUnstuckSpawnPoint.global_position
	Global.dialog = %Dialog
	Global.dialog_timer = %DialogTimer
	Global.item_name_label = %ItemName
	Global.key_pickup = %KeyPickup

	%BackButton.pressed.connect(on_back_button_pressed)
	%DialogTimer.timeout.connect(Global.on_dialog_timer_timeout)


func change_camera(camera: Camera3D) -> void:
	if camera == get_viewport().get_camera_3d():
		return

	Global.last_camera = get_viewport().get_camera_3d()

	if Global.last_camera not in [%MainCamera, %BathroomCamera]:
		Global.current_interaction_area.input_ray_pickable = true

	%Black.show()
	%Animations.play("BlackFadeIn")
	await %Animations.animation_finished
	Input.set_custom_mouse_cursor(null)

	if %MainCamera.is_current() and camera == %BathroomCamera:
		Global.player.global_position = %BathroomSpawnPoint.global_position

	elif %BathroomCamera.is_current() and camera == %MainCamera:
		Global.player.global_position = %LivingRoomSpawnPoint.global_position

	elif Global.tv_cam.is_current():
		Global.remote.global_transform = Global.remote.original_transform

	if not camera == Global.puzderko.get_node("Camera3D"):
		for node : Node in get_tree().get_nodes_in_group("Reset"):
			node.reset()

	camera.make_current()

	if camera in [%MainCamera, %BathroomCamera]:
		Global.player.show()

	else:
		Global.player.hide()

		if (not Global.nightstand.first_inspection and not Global.dining_wardrobe.first_inspection) \
		or  not get_viewport().get_camera_3d() == Global.dining_wardrobe.cam:
			%BackButton.show()

	%Animations.play_backwards("BlackFadeIn")
	await %Animations.animation_finished
	%Black.hide()


func on_back_button_pressed() -> void:
	if not Global.current_note == null:
		Global.current_note.transform = Global.current_note.original_transform
		Global.current_note = null
		return

	if Global.puzderko.inspecting:
		Global.puzderko.get_node("%Drawerz").cam.make_current()
		Global.last_camera = %MainCamera
		Global.puzderko.inspecting = false
		Global.puzderko.get_node("PadlockUI").hide()

		if Global.puzderko.code_complete:
			Global.puzderko.get_node("puzderko_top").rotate_x(deg_to_rad(-100))
			Global.puzderko.input_ray_pickable = false

		return

	%BackButton.hide()
	change_camera(Global.last_camera)
	Global.player.inspecting = false

	if Global.nightstand.first_inspection:
		Global.nightstand.first_inspection = false
		await %Animations.animation_finished
		Global.show_dialog("I must have fallen asleep while working...", 5.0)
		await %DialogTimer.timeout
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.player.movement_disabled = false
		for node : Node in get_tree().get_nodes_in_group("Inspectables"):
			node.interaction_area.input_ray_pickable = true
