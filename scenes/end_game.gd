extends Node


func _ready() -> void:
	print($Player.animations.is_playing())
	$Player.animations.pause()
	$Animations.play("BlackFadeOut")
	await $Animations.animation_finished
	$Player.animations.play()
	await get_tree().create_timer(5.0).timeout
	$Animations.play_backwards("BlackFadeOut")
	await $Animations.animation_finished
	$Camera3D2.make_current()
	$Player.animations.pause()
	$Player.position = Vector3(2.781, 0.178, -0.90)
	$Player.rotation.y = deg_to_rad(90.0)
	$Animations.play("BlackFadeOut")
	$Player.animations.play("ending_scene")
	await get_tree().create_timer(2.0).timeout
	%Dialog.text = "What a strange dream. Maybe I really should take a break..."
	%Dialog.show()
	await get_tree().create_timer(7.0).timeout
	$Animations.play_backwards("BlackFadeOut")
	await $Animations.animation_finished
	get_tree().change_scene_to_packed(load("res://features/main_menu/main_menu.tscn"))
