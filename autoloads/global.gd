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


func _process(_delta: float) -> void:
	DebugPanel.add_property("item_in_hand", item_in_hand, 1)
	DebugPanel.add_property("item_slot", item_slot, 2)
	DebugPanel.add_property("last_camera", last_camera, 3)
	DebugPanel.add_property("current_camera", get_viewport().get_camera_3d(), 4)
