extends TextureButton

signal shop_me_pressed(icon_name)

func _on_shop_button_pressed():
	emit_signal("shop_me_pressed", name)
