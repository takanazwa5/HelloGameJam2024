extends Door


const BATHROOM_KEY_ITEM_RES = preload("res://features/items/bathroom_key/bathroom_key_item_res.tres")


func _ready() -> void:
	super()

	DebugConsole.create_command("bathroom_get_key", func() -> void: has_key = true)

	SignalBus.item_clicked.connect(_on_item_picked_up)


func _interact() -> void:
	SignalBus.bathroom_door_interaction.emit()


func _on_item_picked_up(p_item: Item) -> void:
	if p_item.item_res == BATHROOM_KEY_ITEM_RES:
		has_key = true
