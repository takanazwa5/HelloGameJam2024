extends Node


@warning_ignore("unused_signal")
signal floor_click(pos: Vector3)

@warning_ignore("unused_signal")
signal inspectable_clicked(pos: Vector3)

@warning_ignore("unused_signal")
signal navigation_to_inspectable_finished

@warning_ignore("unused_signal")
signal freeroaming_started

@warning_ignore("unused_signal")
signal change_camera(camera: Camera3D)

@warning_ignore("unused_signal")
signal camera_changed(from: Camera3D, to: Camera3D)

@warning_ignore("unused_signal")
signal back_button_pressed

@warning_ignore("unused_signal")
signal unstuck_button_pressed

@warning_ignore("unused_signal")
signal create_dialog(text: String)
