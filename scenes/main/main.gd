class_name Main extends Node


func _ready() -> void:
	Global.main = self
	Global.main_camera = %MainCamera

	%BackButton.pressed.connect(on_back_button_pressed)


func change_camera(camera: Camera3D) -> void:
	%Black.show()
	%Animations.play("BlackFadeIn")
	await %Animations.animation_finished
	camera.make_current()
	Input.set_custom_mouse_cursor(null)

	if camera == %MainCamera:
		%BackButton.hide()
		Global.player.show()
	else:
		%BackButton.show()
		Global.player.hide()

	%Animations.play_backwards("BlackFadeIn")
	await %Animations.animation_finished
	%Black.hide()


func on_back_button_pressed() -> void:
	change_camera(%MainCamera)
	Global.player.inspecting = false
