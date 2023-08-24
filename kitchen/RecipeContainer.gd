extends VBoxContainer

var textures = [
	load("res://assets/kitchen/scaled/icons/ingredients/burgerpattyicon.png"),
	load("res://assets/kitchen/scaled/icons/ingredients/burgercheeseicon.png")
]

var names = [
	"Patty",
	"Cheese"
]

var recipe = []

var visible_ingredients = []

var burger = []

var burger_match = 0

var next_ingredient

var index
func _ready():
	for ingredient in get_children():
		if ingredient.name != "TopBun" and ingredient.name != "BottomBun":
			randomize()
			index = randi()%textures.size()
			ingredient.texture = textures[index]
			randomize()
			if randi() % 2 == 0:
				ingredient.visible = false
			else:
				ingredient.visible = true
				visible_ingredients.insert(0, ingredient)
				recipe.append(names[index])
	recipe.invert()
	visible_ingredients.append(get_node("TopBun"))
	recipe.append("TopBun")
	recipe.insert(0, "BottomBun")
	#next_ingredient = recipe[0]
	#print("next ingredient: ", next_ingredient)

func Update_Ingredient_Lights(how_many):
	for i in range(visible_ingredients.size()):
		visible_ingredients[i].modulate = Color(1.0,1.0,1.0,0.39)
	for i in range(how_many):
		visible_ingredients[i].modulate = Color(1.0,1.0,1.0,1.0)
	if how_many == 0:
		next_ingredient = null
	elif how_many <= recipe.size():
		next_ingredient = recipe[how_many-1]
	else:
		next_ingredient = "none"
	
	#print("next ingredient: ", next_ingredient)

func _on_Kitchen_tree_changed(children):
	burger = children
	burger_match = 0
	#print("burger size: ",burger.size())
	#print(burger)
	for i in range(min(burger.size(), recipe.size())):
		if burger[i].my_name == recipe[i]:
			burger_match += 1
		else:
			break
	#print("burger_match", burger_match)
	Update_Ingredient_Lights(burger_match-1)
