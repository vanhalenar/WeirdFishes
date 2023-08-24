extends Control

func _on_Menu_pressed():
	print("pressed menu")


func _on_Book_pressed():
	print("pressed Book")


func _on_Menu_mouse_entered():
	$VBoxContainer/Menu/Label.visible = true

func _on_Book_mouse_entered():
	$VBoxContainer/Book/Label.visible = true

func _on_Menu_mouse_exited():
	$VBoxContainer/Menu/Label.visible = false
	
func _on_Book_mouse_exited():
	$VBoxContainer/Book/Label.visible = false
	
