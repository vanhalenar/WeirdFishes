extends TextureButton

signal Clicked_Hat(hat_name)

func _on_HatButton_pressed():
	emit_signal("Clicked_Hat", name)
