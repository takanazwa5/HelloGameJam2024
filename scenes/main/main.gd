class_name Main extends Node


var last_camera : Camera3D
var last_slot_clicked : InventorySlot
var item_in_hand : ItemRes
var click_handled : bool = false
var inspecting_note : bool = false
var current_note : Note


func _ready() -> void:
	%BackButton.pressed.connect(_on_back_button_pressed)
	%DialogTimer.timeout.connect(_on_dialog_timer_timeout)
	SignalBus.change_camera.connect(_change_camera)
	SignalBus.navigation_to_inspectable_finished.connect(_on_navigation_to_inspectable_finished)
	SignalBus.unstuck_button_pressed.connect(_on_unstuck_button_pressed)
	SignalBus.create_dialog.connect(_create_dialog)
	SignalBus.inventory_slot_mouse_entered.connect(_on_inventory_slot_mouse_entered)
	SignalBus.inventory_slot_mouse_exited.connect(_on_inventory_slot_mouse_exited)
	SignalBus.inventory_slot_pressed.connect(_on_inventory_slot_pressed)
	SignalBus.interactable_clicked.connect(_on_interactable_clicked)
	SignalBus.change_cursor.connect(_change_cursor)
	SignalBus.bathroom_door_interaction.connect(_on_bathroom_door_interaction)
	SignalBus.note_inspection.connect(_on_note_inspection)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:

		if event.button_index == MOUSE_BUTTON_LEFT:
			#print(_shoot_ray())

			_deffered_click_check.call_deferred()


func _process(_delta: float) -> void:
	DebugPanel.add_property("FPS", Engine.get_frames_per_second(), 1)
	DebugPanel.add_property("item in hand", item_in_hand, 4)


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


func _on_navigation_to_inspectable_finished() -> void:
	await SignalBus.camera_changed
	%BackButton.show()
	%Player.hide()


func _on_back_button_pressed() -> void:
	if inspecting_note:
		current_note.reset()
		current_note = null
		inspecting_note = false
		return

	SignalBus.back_button_pressed.emit()
	%BackButton.hide()
	_change_camera(last_camera)
	await SignalBus.camera_changed
	%Player.show()


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


func _create_dialog(p_text: String) -> void:
	%Dialog.text = p_text
	%Dialog.show()
	%DialogTimer.wait_time = p_text.length() / 10.0
	%DialogTimer.start()


func _on_dialog_timer_timeout() -> void:
	%Dialog.hide()
	SignalBus.dialog_timer_timeout.emit()


func _on_inventory_slot_mouse_entered(p_slot: InventorySlot) -> void:
	%ItemName.text = p_slot.item_res.display_name
	%ItemName.show()


func _on_inventory_slot_mouse_exited() -> void:
	%ItemName.hide()


func _on_inventory_slot_pressed(p_slot: InventorySlot) -> void:
	if not p_slot.item_res.type == ItemRes.Type.USABLE:
		return

	item_in_hand = p_slot.item_res
	last_slot_clicked = p_slot
	Input.set_custom_mouse_cursor(p_slot.item_res.icon, Input.CURSOR_ARROW, Vector2(16, 16))


func _on_interactable_clicked(p_interactable: Interactable) -> void:
	click_handled = true

	if item_in_hand is not ItemRes:
		_create_dialog(p_interactable.no_item_dialog)
		return

	if not item_in_hand == p_interactable.required_item:
		_create_dialog("I can't use that here.")
		return

	p_interactable.interact()
	last_slot_clicked.queue_free()


func _change_cursor(p_texture: Texture2D) -> void:
	if item_in_hand is ItemRes:
		return

	if p_texture is not Texture2D:
		Input.set_custom_mouse_cursor(null)
		return

	Input.set_custom_mouse_cursor(p_texture, Input.CURSOR_ARROW, Vector2(16, 16))


func _deffered_click_check() -> void:
	click_handled = false

	if item_in_hand is not ItemRes:
		return

	item_in_hand = null
	_change_cursor(null)


func _on_bathroom_door_interaction() -> void:
	if %Player.room == Level.Room.LIVING_ROOM:
		_change_camera(%BathroomCamera)
		await SignalBus.camera_changed
		%Player.position = %BathroomSpawnPoint.position
		%Player.room = Level.Room.BATHROOM

	elif %Player.room == Level.Room.BATHROOM:
		_change_camera(%LivingRoomCamera)
		await SignalBus.camera_changed
		%Player.position = %LivingRoomSpawnPoint.position
		%Player.room = Level.Room.LIVING_ROOM


func _on_note_inspection(p_note: Note) -> void:
	current_note = p_note
	inspecting_note = true
