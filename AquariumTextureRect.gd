extends TextureRect

var food_inst

var object = null
var hat = null
var sprite
onready var ysort = get_node("YSort")

func _on_Node2D_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			food_inst = load("res://misc/FoodBit.tscn").instance()
			food_inst.global_position = event.position
			$YSort.add_child(food_inst)


func _on_UI_Bought_Item(bought_item_name, number):
	object = load("res://decorationscenes/" + bought_item_name.capitalize() + ".tscn").instance()
	sprite = object.get_node("Sprite")
	sprite.texture = load("res://assets/decorations/" + bought_item_name + "/" + String(number) + ".png")
	ysort.add_child(object)
	object.global_position = Vector2(158, 617)
	object.scale = Vector2(4, 4)
	object.select()


func _on_UI_Bought_Hat(bought_hat_name):
	hat = load("res://decorationscenes/hats/" + bought_hat_name.capitalize() + ".tscn").instance()
	add_child(hat)
	hat.global_position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
