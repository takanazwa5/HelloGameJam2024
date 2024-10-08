extends Interactable


@export var drawer_openable : Openable


func _ready() -> void:
	assert(drawer_openable is Openable, "Drawer not assigned for %s" % get_path())


func interact() -> void:
	drawer_openable.locked = false
	set_script(null)
	SignalBus.change_cursor.emit(null)
