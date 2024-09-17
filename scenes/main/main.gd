class_name Main extends Node


func _ready() -> void:
	Global.main = self
	Global.main_camera = %MainCamera
	Global.bathroom_camera = %BathroomCamera

	%BackButton.pressed.connect(on_back_button_pressed)


func change_camera(camera: Camera3D) -> void:
	%Black.show()
	%Animations.play("BlackFadeIn")
	await %Animations.animation_finished
	Input.set_custom_mouse_cursor(null)

	if %MainCamera.is_current() and camera == %BathroomCamera:
		Global.player.global_position = %BathroomSpawnPoint.global_position

	elif %BathroomCamera.is_current() and camera == %MainCamera:
		Global.player.global_position = %LivingRoomSpawnPoint.global_position

	camera.make_current()

	if camera == %MainCamera:
		%BackButton.hide()
		Global.player.show()
	elif not camera == %BathroomCamera:
		%BackButton.show()
		Global.player.hide()

	%Animations.play_backwards("BlackFadeIn")
	await %Animations.animation_finished
	%Black.hide()


func on_back_button_pressed() -> void:
	change_camera(%MainCamera)
	Global.player.inspecting = false
