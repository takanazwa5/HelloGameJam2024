extends Openable


const MATERIAL_OPENED : Material = preload("res://scenes/level/materials/microwave_opened_2.tres")


func _ready() -> void:
	super()

	SignalBus.tv_code_complete.connect(_on_tv_code_complete)

	DebugConsole.create_command("microwave_unlock", _unlock)


func interact() -> void:
	if locked:
		SignalBus.create_dialog.emit("It's not doing anything.")
		return

	if animation_player.is_playing():
		return

	if not opened:
		animation_player.play("Open")
		%MicrowaveDoor.play()
		opened = true


func _on_tv_code_complete() -> void:
	if locked:
		_unlock()


func _unlock() -> void:
	locked = false
	%MicrowaveMesh.mesh.surface_set_material(0, MATERIAL_OPENED)
	%MicrowaveDing.play()
