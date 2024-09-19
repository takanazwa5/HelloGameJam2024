class_name TV extends MeshInstance3D


const ONE : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/1_.png")
const TWO : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/2.png")
const THREE : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/3.png")
const SIX : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/6.png")
const SEVEN : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/7.png")
const NINE : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/9.png")
const NOISE : Texture2D = preload("res://scenes/house/textures/Living Room/TV/213769/white noise.png")


var digits_correct : Array[bool] = []


func _ready() -> void:
	for i : int in 5:
		digits_correct.append(false)

	Global.tv = self
	DebugConsole.create_command("tv_button", button_pressed)


func button_pressed(digit: int) -> void:
	match digit:

		1:
			if digits_correct[0]:
				digits_correct[1] = true
				change_texture(THREE)

			else:
				reset()

		2:
			if not digits_correct[0]:
				digits_correct[0] = true
				change_texture(ONE)

			else:
				reset()

		3:
			if digits_correct[1]:
				digits_correct[2] = true
				change_texture(SEVEN)

			else:
				reset()

		6:
			if digits_correct[3]:
				digits_correct[4] = true
				change_texture(NINE)

			else:
				reset()

		7:
			if digits_correct[2]:
				digits_correct[3] = true
				change_texture(SIX)

			else:
				reset()

		9:
			if digits_correct[4]:
				print("CODE COMPLETED")

			else:
				reset()

		_:
			reset()


func reset() -> void:
	for i : int in 5:
		digits_correct[i] = false

	change_texture(NOISE)


func change_texture(texture: Texture2D) -> void:
	mesh.surface_get_material(0).albedo_texture = texture
