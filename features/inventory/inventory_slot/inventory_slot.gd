class_name InventorySlot extends PanelContainer


var item_res : ItemRes:
	set(val):
		item_res = val
		$TextureButton.texture_normal = item_res.thumbnail if item_res is ItemRes else null


func _ready() -> void:
	$TextureButton.pressed.connect(on_texture_button_pressed)
	$TextureButton.mouse_entered.connect(on_mouse_entered)
	$TextureButton.mouse_exited.connect(on_mouse_exited)


func on_mouse_entered() -> void:
	Global.item_name_label.text = item_res.display_name
	Global.item_name_label.show()


func on_mouse_exited() -> void:
	Global.item_name_label.hide()


func on_texture_button_pressed() -> void:
	if Global.main_camera.is_current() or Global.bathroom_camera.is_current():
		return

	Input.set_custom_mouse_cursor(item_res.icon, Input.CURSOR_ARROW, Vector2(16, 16))
	$TextureButton.texture_normal = null
	Global.item_in_hand = item_res
	Global.item_slot = self
