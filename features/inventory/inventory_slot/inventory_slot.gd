class_name InventorySlot extends PanelContainer


var item_res : ItemRes:
	set(val):
		item_res = val
		$TextureButton.texture_normal = item_res.thumbnail if item_res is ItemRes else null


func _ready() -> void:
	$TextureButton.pressed.connect(_on_texture_button_pressed)
	$TextureButton.mouse_entered.connect(_on_mouse_entered)
	$TextureButton.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	pass


func _on_mouse_exited() -> void:
	pass


func _on_texture_button_pressed() -> void:
	pass
