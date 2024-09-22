class_name Microwave extends Interactable


const OPENED_MATERIAL : Material = preload("res://scenes/house/textures/items_2/microwave_opened_2.tres")


var locked : bool = true


func _ready() -> void:
	super()

	Global.microwave = self

	DebugConsole.create_command("unlock_microwave", unlock)
	DebugConsole.create_command("play_ding", func() -> void: %MicrowaveDing.play())


func _input_event(camera: Node, event: InputEvent, \
_event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:

	if not can_interact:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if not camera == cam:
			return

		if required_item is ItemRes:
			if Global.item_in_hand == required_item:
				Global.item_slot.queue_free()
				Global.item_in_hand = null
				Global.item_slot = null
				Input.set_custom_mouse_cursor(null)
				interact()

			elif not Global.item_in_hand == null:
				Global.show_dialog("I can't use it here.", 2.0)
				Input.set_custom_mouse_cursor(null)
				Global.item_slot.get_node("TextureButton").texture_normal = Global.item_slot.item_res.thumbnail
				Global.item_in_hand = null
				Global.item_slot = null

		elif required_item == null:
			if Global.item_in_hand == null:
				if not locked:
					interact()
				else:
					Global.show_dialog("It won't open.", 2.0)

			else:
				Global.show_dialog("I can't use it here.", 2.0)
				Input.set_custom_mouse_cursor(null)
				Global.item_slot.get_node("TextureButton").texture_normal = Global.item_slot.item_res.thumbnail
				Global.item_in_hand = null
				Global.item_slot = null


func interact() -> void:
	%microwave_door.rotation.y = deg_to_rad(-90)
	%MicrowaveLight.show()
	%MicrowaveOpen.play()


func reset() -> void:
	%microwave_door.rotation.y = 0
	%MicrowaveLight.hide()


func unlock() -> void:
	locked = false
	%microwave.mesh.surface_set_material(0, OPENED_MATERIAL)
	%MicrowaveDing.play()
