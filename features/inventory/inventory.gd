class_name Inventory extends Control


const INVENTORY_SLOT : PackedScene = preload("res://features/inventory/inventory_slot/inventory_slot.tscn")


func _ready() -> void:
	pass

func add_item(item: Item) -> void:
	var new_slot : InventorySlot = INVENTORY_SLOT.instantiate()
	new_slot.item_res = item.item_res
	%Slots.add_child(new_slot)
	item.queue_free()
	Input.set_custom_mouse_cursor(null)
