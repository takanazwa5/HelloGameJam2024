extends MeshInstance3D


const REMOTE_ITEM_RES = preload("res://features/items/remote/remote_item_res.tres")
const ONE = preload("res://scenes/level/textures/Living Room/TV/213769/1_.png")
const TWO = preload("res://scenes/level/textures/Living Room/TV/213769/2.png")
const THREE = preload("res://scenes/level/textures/Living Room/TV/213769/3.png")
const SIX = preload("res://scenes/level/textures/Living Room/TV/213769/6.png")
const SEVEN = preload("res://scenes/level/textures/Living Room/TV/213769/7.png")
const NINE = preload("res://scenes/level/textures/Living Room/TV/213769/9.png")
const NOISE = preload("res://scenes/level/textures/Living Room/TV/213769/white noise.png")


@export var camera : Camera3D


var has_remote : bool = false
var digits_correct : Array[bool]


func _ready() -> void:
	assert(camera is Camera3D, "Camera not assigned for %s" % get_path())

	SignalBus.camera_changed.connect(_on_camera_changed)
	SignalBus.item_clicked.connect(_on_item_picked_up)
	SignalBus.remote_button_pressed.connect(_on_remote_button_pressed)

	for i : int in 5:
		digits_correct.append(false)


func _on_camera_changed(_p_from: Camera3D, p_to: Camera3D) -> void:
	if p_to == camera and has_remote:
		%Remote.show()
		return
	%Remote.hide()


func _on_item_picked_up(p_item: Item) -> void:
	if p_item.item_res == REMOTE_ITEM_RES:
		has_remote = true


func _on_remote_button_pressed(p_index: int) -> void:
	match p_index:

		1:
			if digits_correct[0]:
				digits_correct[1] = true
				_change_texture(THREE)

			else:
				_reset()

		2:
			if not digits_correct[0]:
				digits_correct[0] = true
				_change_texture(ONE)

			else:
				_reset()

		3:
			if digits_correct[1]:
				digits_correct[2] = true
				_change_texture(SEVEN)

			else:
				_reset()

		6:
			if digits_correct[3]:
				digits_correct[4] = true
				_change_texture(NINE)

			else:
				_reset()

		7:
			if digits_correct[2]:
				digits_correct[3] = true
				_change_texture(SIX)

			else:
				_reset()

		9:
			if digits_correct[4]:
				_reset()
				SignalBus.tv_code_complete.emit()

			else:
				_reset()

		_:
			_reset()


func _reset() -> void:
	for i : int in 5:
		digits_correct[i] = false

	_change_texture(NOISE)


func _change_texture(texture: Texture2D) -> void:
	mesh.surface_get_material(0).albedo_texture = texture
