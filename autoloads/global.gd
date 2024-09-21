extends Node


var player : Player
var main : Main
var main_camera : Camera3D
var bathroom_camera : Camera3D
var inventory : Inventory

var item_in_hand : ItemRes = null
var item_slot : InventorySlot = null

var current_interaction_area : Area3D

var fridge : Fridge
var fridge_camera : Camera3D

var cupboard_shelves : Array[CupboardShelves]
var cupboard_shelves_camera : Camera3D

var cupboard_smol_l : CupboardSmolL
var cupboard_smol_r : CupboardSmolR
var cupboard_smol_camera : Camera3D

var last_camera : Camera3D

var sink_door : SinkDoor
var sink_camera : Camera3D

var living_room_unstuck_spawn_point : Vector3
var bathroom_unstuck_spawn_point : Vector3

var nightstand : Nightstand

var dialog : Label
var dialog_timer : Timer

var dining_wardrobe : DiningWardrobe

var bathroom_door : Door
var exit_door : Door

var tv : TV
var tv_cam : Camera3D

var remote : Remote

var item_name_label : Label

var has_remote : bool = false

var current_note : Note = null

var microwave : Microwave

var key_pickup : AudioStreamPlayer

var moving_to : Inspectable

var puzderko : Area3D


func _ready() -> void:
	DebugConsole.create_command("note_water", note_water_visibility)
	DebugConsole.create_command("note_water_area", note_water_area_visibility)


func _input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not item_in_hand is ItemRes:
			return

		var viewport : Viewport = get_viewport()
		var camera : Camera3D = viewport.get_camera_3d()
		var mouse_pos : Vector2 = viewport.get_mouse_position()
		var from : Vector3 = camera.global_position
		var to : Vector3 = from + camera.project_ray_normal(mouse_pos) * 100
		var space : PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
		query.collide_with_areas = true
		query.collision_mask = 0b10
		query.from = from
		query.to = to
		var result : Dictionary = space.intersect_ray(query)

		if result.is_empty():
			Input.set_custom_mouse_cursor(null)
			item_slot.get_node("TextureButton").texture_normal = item_slot.item_res.thumbnail
			item_in_hand = null
			item_slot = null
			return

		if result.collider is not Interactable:
			Input.set_custom_mouse_cursor(null)
			item_slot.get_node("TextureButton").texture_normal = item_slot.item_res.thumbnail
			item_in_hand = null
			item_slot = null
			return

		if result.collider is OldClock and Global.dining_wardrobe.first_inspection:
			if not item_in_hand == result.collider.required_item:
				return
			Input.set_custom_mouse_cursor(null)
			item_slot.get_node("TextureButton").texture_normal = item_slot.item_res.thumbnail
			item_in_hand = null
			item_slot = null
			show_dialog("Still not working. I'll hang on to the bateries, they may come in handy.", 5.0)
			result.collider.can_interact = false
			await dialog_timer.timeout
			Global.main.get_node("%BackButton").show()
			Global.dining_wardrobe.first_inspection = false
			return


func _process(_delta: float) -> void:
	DebugPanel.add_property("item_in_hand", item_in_hand, 1)
	DebugPanel.add_property("item_slot", item_slot, 2)
	DebugPanel.add_property("last_camera", last_camera, 3)
	DebugPanel.add_property("current_camera", get_viewport().get_camera_3d(), 4)
	DebugPanel.add_property("FPS", Engine.get_frames_per_second(), 5)


func show_dialog(text: String, _time: float) -> void:
	var char_num : int = text.length()
	dialog_timer.wait_time = float(char_num) / 10.0
	dialog.text = text
	dialog.show()
	dialog_timer.start()


func on_dialog_timer_timeout() -> void:
	dialog.hide()


func note_water_visibility(state: bool) -> String:
	tv.get_node("%NoteWater").visible = state
	return "NoteWater visible = %s" % state


func note_water_area_visibility(state: bool) -> String:
	tv.get_node("%NoteWaterArea").visible = state
	return "NoteWaterArea visible = %s" % state
