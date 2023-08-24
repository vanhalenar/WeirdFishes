extends Control

#fish book variables
onready var fish_panel = $CenterContainer/HBoxContainer/CenterContainer/PanelContainer/VBoxContainer2/VBoxContainer/CenterContainer/PanelContainer
onready var fish_grid = $CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer/ScrollContainer/GridContainer
onready var fish_label = $CenterContainer/HBoxContainer/CenterContainer/PanelContainer/VBoxContainer2/VBoxContainer/Label
onready var fish_desc = $CenterContainer/HBoxContainer/CenterContainer/PanelContainer/VBoxContainer2/VBoxContainer/CenterContainer2/PanelContainer/Label

onready var tween = $Tween

var book_open = true
var shop_open = true
var hat_shop_open = false

var fish_inst = null

#shop variables
onready var item_label = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Label
onready var item_price_label = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/BuyLabel
onready var item_sprite0 = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Sprite0
onready var item_sprite1 = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Sprite1
onready var item_sprite2 = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Sprite2
onready var shop_tween = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Tween
onready var item_sprite_container = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2
onready var hat_grid = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/ScrollContainer/HatContainer
onready var plant_grid = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/ScrollContainer/PlantContainer
onready var display_panel = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer
onready var left_button = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Left
onready var right_button_container = $CenterContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer
onready var active_sprite = item_sprite0
onready var active_sprite_number = 0
var next_sprite

var hat_fish_inst = null

var selected_item = "snakeplant"

var selected_hat = "beanie"

var hat_sprite

signal Bought_Item(bought_item_name, number)

signal Bought_Hat(bought_hat_name)

func _ready():
	Close_Book()
	Close_Shop()

func Close_Book():
	book_open = false
	tween.interpolate_property(
		$CenterContainer, 
		"rect_global_position", 
		$CenterContainer.rect_global_position, 
		Vector2($CenterContainer.rect_global_position.x, get_viewport().size.y),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	tween.start()

func Open_Book():
	book_open = true
	tween.interpolate_property(
		$CenterContainer, 
		"rect_global_position", 
		$CenterContainer.rect_global_position, 
		Vector2(
			(get_viewport().size.x - $CenterContainer.rect_size.x)/2, 
			(get_viewport().size.y - $CenterContainer.rect_size.y)/2),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	tween.start()

func Close_Shop():
	shop_open = false
	tween.interpolate_property(
		$CenterContainer2, 
		"rect_global_position", 
		$CenterContainer2.rect_global_position, 
		Vector2($CenterContainer2.rect_global_position.x, get_viewport().size.y),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	tween.start()

func Open_Shop():
	shop_open = true
	tween.interpolate_property(
		$CenterContainer2, 
		"rect_global_position", 
		$CenterContainer2.rect_global_position, 
		Vector2(
			(get_viewport().size.x - $CenterContainer2.rect_size.x)/2, 
			(get_viewport().size.y - $CenterContainer2.rect_size.y)/2),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	tween.start()
	
func Remove_Fish():
	fish_panel.remove_child(fish_inst)
	fish_inst.queue_free()
	
func Add_Fish(fish_name):
	fish_inst = load("res://fishscenes/" + fish_name + ".tscn").instance()
	fish_inst.mode = 1
	fish_panel.add_child(fish_inst)
	fish_inst.position = Vector2(fish_panel.rect_size.x/2, fish_panel.rect_size.y/2)
	fish_inst.movement_state = 2
	fish_inst.set_collision_layer_bit(0, false)
	fish_inst.set_collision_mask_bit(0, false)
	fish_label.text = fish_name.to_lower()
	fish_desc.text = load("res://fishscenes/resources/" + fish_name.to_lower() + ".tres").description

func Refresh_Icons():
	for i in fish_grid.get_children():
		if get_tree().root.get_child(0).get_node("YSort").has_node(i.name):
			Update_Icon(i)
			
func Update_Icon(node):
	node.get_node("Label").text = node.name.to_lower()
	node.get_node("TextureButton").texture_normal = load("res://assets/portraits/" + node.name.to_lower() +"portrait.png")

func Update_Shop_Display(item_name):
	var item_res = load("res://shop/resources/" + item_name.to_lower() + ".tres")
	item_label.text = item_res.name
	var item_price = String(item_res.price)
	item_price_label.text = "buy (" + item_price + "$)!"
	Switch_Item_Sprites(item_name)
	
func Switch_Sprites_Right():
	if active_sprite == item_sprite0:
		next_sprite = item_sprite1
		active_sprite_number = 1
	elif active_sprite == item_sprite1:
		next_sprite = item_sprite2
		active_sprite_number = 2
	elif active_sprite == item_sprite2:
		next_sprite = item_sprite0
		active_sprite_number = 0
	
	shop_tween.interpolate_property(
		active_sprite, 
		"position", 
		Vector2(120, 70), 
		Vector2(353, 70),
		0.6,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	shop_tween.interpolate_property(
		next_sprite, 
		"position", 
		Vector2(-114, 70), 
		Vector2(120, 70),
		0.6,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	shop_tween.start()
	active_sprite = next_sprite

func Switch_Sprites_Left():
	if active_sprite == item_sprite0:
		next_sprite = item_sprite2
		active_sprite_number = 2
	elif active_sprite == item_sprite1:
		next_sprite = item_sprite0
		active_sprite_number = 0
	elif active_sprite == item_sprite2:
		next_sprite = item_sprite1
		active_sprite_number = 1
	
	shop_tween.interpolate_property(
		active_sprite, 
		"position", 
		Vector2(120, 70), 
		Vector2(-114, 70),
		0.6,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	shop_tween.interpolate_property(
		next_sprite, 
		"position", 
		Vector2(353, 70), 
		Vector2(120, 70),
		0.6,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	shop_tween.start()
	active_sprite = next_sprite
	
func Switch_Item_Sprites(item_name):
	if active_sprite == item_sprite0:
		next_sprite = item_sprite1
		active_sprite_number = 1
		item_sprite1.texture = load("res://assets/decorations/" + item_name.to_lower() + "/1.png")
	elif active_sprite == item_sprite1:
		next_sprite = item_sprite2
		active_sprite_number = 2
		item_sprite2.texture = load("res://assets/decorations/" + item_name.to_lower() + "/2.png")
	elif active_sprite == item_sprite2:
		next_sprite = item_sprite0
		active_sprite_number = 0
		item_sprite0.texture = load("res://assets/decorations/" + item_name.to_lower() + "/0.png")
	shop_tween.interpolate_property(
		active_sprite, 
		"position", 
		Vector2(120, 70), 
		Vector2(353, 70),
		0.6,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	shop_tween.interpolate_property(
		next_sprite, 
		"position", 
		Vector2(120, -156), 
		Vector2(120, 70),
		0.6,
		Tween.TRANS_EXPO,
		Tween.EASE_IN)
	active_sprite = next_sprite
	shop_tween.start()
	yield(shop_tween, "tween_completed")
	if item_sprite0 != active_sprite:
		item_sprite0.texture = load("res://assets/decorations/" + item_name.to_lower() + "/0.png")
	if item_sprite1 != active_sprite:
		item_sprite1.texture = load("res://assets/decorations/" + item_name.to_lower() + "/1.png")
	if item_sprite2 != active_sprite:
		item_sprite2.texture = load("res://assets/decorations/" + item_name.to_lower() + "/2.png")

func Open_Hat_Shop():
	hat_shop_open = true
	plant_grid.visible = false
	hat_grid.visible = true
	left_button.visible = false
	right_button_container.visible = false
	hat_fish_inst = load("res://fishscenes/Oddie.tscn").instance()
	hat_fish_inst.mode = 1
	display_panel.add_child(hat_fish_inst)
	hat_fish_inst.position = Vector2(120, 160)
	hat_fish_inst.movement_state = 2
	hat_fish_inst.set_collision_layer_bit(0, false)
	hat_fish_inst.set_collision_mask_bit(0, false)
	active_sprite.visible = false
	hat_sprite = hat_fish_inst.get_node("Sprite/Hat")
	hat_sprite.texture = load("res://assets/decorations/beanie.png")
	hat_sprite.offset = Vector2(-hat_sprite.texture.get_width()/2, -hat_sprite.texture.get_height())
	item_label.text = "beanie"
	item_price_label.text = String(load("res://shop/resources/beanie.tres").price) + "$"

func Open_Plant_Shop():
	hat_shop_open = false
	hat_grid.visible = false
	plant_grid.visible = true
	left_button.visible = true
	right_button_container.visible = true
	if hat_fish_inst != null:
		hat_fish_inst.queue_free()
		hat_fish_inst = null
	item_sprite0.visible = true
	item_sprite1.visible = true
	item_sprite2.visible = true
	Switch_Item_Sprites("snakeplant")
	Update_Shop_Display("snakeplant")
	
func Change_Hat(hat):
	hat_sprite.texture = load("res://assets/decorations/" + hat + ".png")
	hat_sprite.offset = Vector2(-hat_sprite.texture.get_width()/2, -hat_sprite.texture.get_height())
	item_label.text = hat
	item_price_label.text = String(load("res://shop/resources/"+hat+".tres").price) + "$"
	selected_hat = hat

func _on_BookButton_pressed():
	if shop_open == true:
		Close_Shop()
	if book_open == true:
		Close_Book()
	else:
		Open_Book()
		Refresh_Icons()

func _on_Clicked_Fish(fish_name):
	if fish_inst != null:
		Remove_Fish()
		Add_Fish(fish_name)
	else:
		Add_Fish(fish_name)

func _on_Clicked_Item(item_name):
	Update_Shop_Display(item_name)
	selected_item = item_name


func _on_Right_pressed():
	Switch_Sprites_Left()


func _on_Left_pressed():
	Switch_Sprites_Right()


func _on_ShopButton_pressed():
	if book_open == true:
		Close_Book()
	if shop_open == true:
		Close_Shop()
	else:
		Open_Shop()





func _on_HatButton_pressed():
	Open_Hat_Shop()


func _on_PlantButton_pressed():
	Open_Plant_Shop()


func _on_Clicked_Hat(hat_name):
	Change_Hat(hat_name)


func _on_BuyButton_pressed():
	if hat_shop_open == false:
		emit_signal("Bought_Item", selected_item, active_sprite_number)
	else:
		emit_signal("Bought_Hat", selected_hat)
	Close_Shop()
