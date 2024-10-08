extends Interactable


func interact() -> void:
	%LampALightBulb.show()
	%MorseCodeAnimationPlayer.play("MorseCode")
	set_script(null)
