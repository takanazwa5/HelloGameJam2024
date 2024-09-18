class_name Main extends Node


func _ready() -> void:
	Global.main = self
	Global.main_camera = %MainCamera
	Global.bathroom_camera = %BathroomCamera

	%BackButton.pressed.connect(on_back_button_pressed)


func change_camera(camera: Camera3D) -> void:
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

	for node : Node in get_tree().get_nodes_in_group("Reset"):
		node.reset()

	camera.make_current()

	if camera in [%MainCamera, %BathroomCamera]:
		Global.player.show()

	else:
		%BackButton.show()
		Global.player.hide()

	%Animations.play_backwards("BlackFadeIn")
	await %Animations.animation_finished
	%Black.hide()


func on_back_button_pressed() -> void:
	%BackButton.hide()
	change_camera(Global.last_camera)
	Global.player.inspecting = false
