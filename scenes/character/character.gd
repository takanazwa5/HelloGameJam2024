class_name Character extends Node3D


func inspect_nightstand() -> void:
	get_tree().get_first_node_in_group("Nightstand").inspect()
