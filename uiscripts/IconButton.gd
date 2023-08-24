extends TextureButton

signal me_pressed(icon_name)

func _on_Icon_Button_pressed():
	if self.owner.has_node(name):
		emit_signal("me_pressed", name)
	
