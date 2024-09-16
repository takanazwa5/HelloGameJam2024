class_name InventorySlot extends PanelContainer


var item_res : ItemRes:
	set(val):
		item_res = val
		$TextureButton.texture_normal = item_res.thumbnail if item_res is ItemRes else null


func _ready() -> void:
	$TextureButton.pressed.connect(on_texture_button_pressed)


func on_texture_button_pressed() -> void:
	Input.set_custom_mouse_cursor(item_res.icon, Input.CURSOR_ARROW, Vector2(16, 16))
	$TextureButton.texture_normal = null
	Global.item_in_hand = item_res
	Global.item_slot = self
