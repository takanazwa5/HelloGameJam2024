@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Object:
	_iterate(scene)
	return scene


func _iterate(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh : Mesh = node.get_mesh()

		for surf_idx : int in mesh.get_surface_count():
			var material : BaseMaterial3D = mesh.surface_get_material(surf_idx)
			material.set_cull_mode(BaseMaterial3D.CULL_BACK)

			print("cull_mode set to CULL_BACK for %s (surface %s)" % [node.name, surf_idx])

	for child : Node in node.get_children():
		_iterate(child)
