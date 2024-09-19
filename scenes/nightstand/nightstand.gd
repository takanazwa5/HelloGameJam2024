class_name Nightstand extends Inspectable


var first_inspection : bool = true


func _ready() -> void:
	super()

	Global.nightstand = self


func inspect() -> void:
	super()

	if first_inspection:
		%Animations.play("Zoom")
		await %Animations.animation_finished
		Global.main.get_node("%BackButton").pressed.emit()


func clock_dialog() -> void:
	Global.show_dialog("What happened to this clock?", 5.0)
