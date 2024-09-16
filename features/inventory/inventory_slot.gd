class_name InventorySlot extends PanelContainer


var item_res : ItemRes:
	set(val):
		item_res = val
		$TextureButton.texture_normal = item_res.thumbnail
