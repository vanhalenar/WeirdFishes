extends TextureButton

signal Clicked_Item(item_name)



func _on_item_pressed():
	emit_signal("Clicked_Item", name)
