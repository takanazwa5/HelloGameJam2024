extends Control


var label_settings : LabelSettings = LabelSettings.new()


@onready var labels_container: VBoxContainer = %LabelsContainer


func _ready() -> void:
	show()

	label_settings.outline_color = Color.BLACK
	label_settings.outline_size = 10


func add_property(title: String, value: Variant, order: int) -> void:
	if labels_container.get_node_or_null(title) == null:
		var label_instance : Label = Label.new()
		label_instance.name = title
		label_instance.label_settings = label_settings
		labels_container.add_child(label_instance)

	elif visible:
		labels_container.get_node(title).text = title + ": " + str(value)
		labels_container.move_child(labels_container.get_node(title), order)
