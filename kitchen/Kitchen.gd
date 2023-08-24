extends TextureRect

var part

var held_object = null

var expected_ingredient

onready var recipe = $RecipeCard/RecipeContainer.recipe

var points = 0

signal tree_changed(children)

func _ready():
	for i in $PartButtons.get_children():
		i.connect("clicked", self, "on_pickable_clicked")
		i.connect("spawn_part", self, "_on_Spawn_Part")
		i.connect("first_dropped", self, "Update_Points")
		i.connect("first_impact", self, "on_First_Impact")
	#print(recipe)

func on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.get_parent().remove_child(held_object)
		$BurgerParts.add_child(held_object)
		emit_signal("tree_changed", $BurgerParts.get_children())
		held_object.pickup()
	
	$BurgerParts.move_child(held_object, $BurgerParts.get_child_count()-1)

func on_First_Impact():
	print("first impact")

func Update_Points():
	pass
	#print("burger parts: ", $BurgerParts.get_children())
	#print("recipe: ", recipe)

func Add_Points(value):
	points += value
	$Label.text = "Score: " + String(points)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null

func _on_Spawn_Part(part_name, position):
	part = load("res://kitchen/" + part_name + ".tscn").instance()
	part.add_to_group("pickable")
	part.connect("clicked", self, "on_pickable_clicked")
	part.connect("spawn_part", self, "_on_Spawn_Part")
	part.connect("first_dropped", self, "Update_Points")
	part.connect("first_impact", self, "on_First_Impact")
	$PartButtons.add_child(part)
	part.position = position
	emit_signal("tree_changed", $BurgerParts.get_children())

func _on_Bounds_body_entered(body):
	$BurgerParts.remove_child(body)
	body.queue_free()
	emit_signal("tree_changed", $BurgerParts.get_children())
