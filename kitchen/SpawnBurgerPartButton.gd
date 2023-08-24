extends TextureButton


signal Spawn_Part(part_name, position)

func _on_Spawn_Burger_Part_Button_pressed():
	emit_signal("Spawn_Part", name, rect_global_position)
