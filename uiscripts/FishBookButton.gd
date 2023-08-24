extends TextureButton

signal Clicked_Fish(fish_name)

onready var fish_name = get_parent().name

func _on_TextureButton_pressed():
	if get_parent().get_node("Label").text != "???":
		emit_signal("Clicked_Fish", fish_name)
