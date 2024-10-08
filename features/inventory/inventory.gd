class_name Inventory extends Control


const INVENTORY_SLOT : PackedScene = preload("res://features/inventory/inventory_slot/inventory_slot.tscn")


func _ready() -> void:
	SignalBus.item_clicked.connect(_on_item_picked_up)


func _add_item(p_item: Item) -> void:
	var new_slot : InventorySlot = INVENTORY_SLOT.instantiate()
	new_slot.item_res = p_item.item_res
	%Slots.add_child(new_slot)
	SignalBus.change_cursor.emit(null)


func _on_item_picked_up(p_item: Item) -> void:
	_add_item(p_item)
	p_item.queue_free()
