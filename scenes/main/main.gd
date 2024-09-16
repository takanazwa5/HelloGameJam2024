class_name Main extends Node


func _ready() -> void:
	SignalBus.activate_camera.connect(change_camera)
	%BackButton.pressed.connect(change_camera.bind(%MainCamera))


func change_camera(camera: Camera3D) -> void:
	%Black.show()
	%Animations.play("BlackFadeIn")
	await %Animations.animation_finished
	camera.make_current()
	Input.set_custom_mouse_cursor(null)

	if camera == %MainCamera:
		%BackButton.hide()
		SignalBus.enable_player_movement.emit()
	else:
		%BackButton.show()
		SignalBus.disable_player_movement.emit()

	%Animations.play_backwards("BlackFadeIn")
	await %Animations.animation_finished
	%Black.hide()
