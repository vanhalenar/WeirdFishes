extends Node2D

const GRID_SIZE = 16.0

var object = null

onready var ysort = get_node("YSort")

var sprite

func _on_UserInterface_bought_item(item_name):
	object = load("res://decorationscenes/" + item_name + ".tscn").instance()
	sprite = object.get_node("Sprite")
	sprite.texture = load("res://assets/decorations/" + item_name + "/" + str(randi()%3) + ".png")
	ysort.add_child(object)
	object.global_position = Vector2(158, 617)
	object.scale = Vector2(4, 4)
	object.select()
	
