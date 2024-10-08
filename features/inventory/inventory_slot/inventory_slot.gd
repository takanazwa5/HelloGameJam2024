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
	SignalBus.inventory_slot_mouse_entered.emit(self)


func _on_mouse_exited() -> void:
	SignalBus.inventory_slot_mouse_exited.emit()


func _on_texture_button_pressed() -> void:
	SignalBus.inventory_slot_pressed.emit(self)
