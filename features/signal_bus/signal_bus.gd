extends Node

@warning_ignore("unused_signal")
signal change_cursor(texture: Texture2D)

@warning_ignore("unused_signal")
signal floor_click(pos: Vector3)

@warning_ignore("unused_signal")
signal inspectable_clicked(inspectable: Inspectable)

@warning_ignore("unused_signal")
signal navigation_to_inspectable_finished

@warning_ignore("unused_signal")
signal freeroaming_started

@warning_ignore("unused_signal")
signal change_camera(camera: Camera3D)

@warning_ignore("unused_signal")
signal camera_changed(from: Camera3D, to: Camera3D)

@warning_ignore("unused_signal")
signal back_button_pressed

@warning_ignore("unused_signal")
signal unstuck_button_pressed

@warning_ignore("unused_signal")
signal create_dialog(text: String)

@warning_ignore("unused_signal")
signal item_clicked(item: Item)

@warning_ignore("unused_signal")
signal inventory_slot_mouse_entered(slot: InventorySlot)

@warning_ignore("unused_signal")
signal inventory_slot_mouse_exited

@warning_ignore("unused_signal")
signal tv_code_complete

@warning_ignore("unused_signal")
signal inventory_slot_pressed(slot: InventorySlot)

@warning_ignore("unused_signal")
signal interactable_clicked(interactable: Interactable)

@warning_ignore("unused_signal")
signal door_clicked(door: Door)

@warning_ignore("unused_signal")
signal bathroom_door_interaction

@warning_ignore("unused_signal")
signal navigation_to_door_finished

@warning_ignore("unused_signal")
signal remote_button_pressed(index: int)

@warning_ignore("unused_signal")
signal dialog_timer_timeout

@warning_ignore("unused_signal")
signal note_inspection(note: Note)
