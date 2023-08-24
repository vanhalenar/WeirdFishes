extends Control

onready var menu = $FishBook
onready var shop = $Shop
onready var tween = $Tween
onready var grid_container = $FishBook/ScrollContainer/GridContainer

onready var fish_name = $FishBook/CardNinePatchRect/Name
#onready var fish_image = $FishBook/CardNinePatchRect/FishImage
onready var fish_desc = $FishBook/CardNinePatchRect/Description
onready var fish_card = $FishBook/CardNinePatchRect
onready var anim_player = $FishBook/CardNinePatchRect/AnimationPlayer

onready var shop_item_name = $Shop/CardNinePatchRect/Name
onready var shop_item_desc = $Shop/CardNinePatchRect/Description
onready var shop_card = $Shop/CardNinePatchRect
onready var shop_item_sprite = $Shop/CardNinePatchRect/Sprite
onready var shop_item_price_label = $Shop/CardNinePatchRect/PriceTag/PriceLabel
onready var shop_anim_player = $Shop/CardNinePatchRect/AnimationPlayer

onready var plants_container = $Shop/PlantsContainer
onready var rocks_container = $Shop/RocksContainer
onready var hats_container = $Shop/HatsContainer
onready var shop_label = $Shop/ShopNinePatchRect/Label

var selected = null

signal bought_item(item_name)

#var fish_res
var fish_inst

func _on_BookButton_toggled(button_pressed):
	if button_pressed == true:
		#print("toggled")
		tween.interpolate_property(menu, "rect_global_position", null, Vector2(640, 360), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		#menu.rect_global_position = Vector2(640, 1000)
		tween.start()
		print(menu.rect_global_position)
		$BookShopButtons/BookButton/Label.visible = true
	else:
		#print("untoggled")
		tween.interpolate_property(menu, "rect_global_position", null, Vector2(640, 1000), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		#menu.rect_global_position = Vector2(640, 360)
		tween.start()
		$BookShopButtons/BookButton/Label.visible = false
		print(menu.rect_global_position)
		

func _on_Fish_me_pressed(icon_name):
	anim_player.play("Shake")
	fish_name.text = icon_name.to_lower()
	if fish_inst != null:
		fish_card.remove_child(fish_inst)
		fish_inst.queue_free()
	fish_inst = load("res://fishscenes/" + icon_name + ".tscn").instance()
	fish_card.add_child(fish_inst)
	fish_inst.state = 3
	fish_inst.position = Vector2(38, 38)
	fish_desc.text = load("res://fishscenes/resources/" + icon_name.to_lower() + ".tres").description
	

func _on_BackButton_pressed():
	#print("untoggled")
	tween.interpolate_property(menu, "rect_global_position", null, Vector2(640, 1000), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	#menu.rect_global_position = Vector2(640, 360)
	tween.start()
	$BookShopButtons/BookButton/Label.visible = false
	print(menu.rect_global_position)
	$BookShopButtons/BookButton.pressed = false


func _on_ShopButton_toggled(button_pressed):
	if button_pressed == true:
		#print("toggled")
		tween.interpolate_property(shop, "rect_global_position", null, Vector2(640, 360), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		#menu.rect_global_position = Vector2(640, 1000)
		tween.start()
		print(shop.rect_global_position)
		$BookShopButtons/ShopButton/Label.visible = true
	else:
		#print("untoggled")
		tween.interpolate_property(shop, "rect_global_position", null, Vector2(640, 1000), 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		#menu.rect_global_position = Vector2(640, 360)
		tween.start()
		$BookShopButtons/ShopButton/Label.visible = false
		print(shop.rect_global_position)


func _on_shop_me_pressed(icon_name):
	shop_item_name.text = load("res://shop/resources/" + icon_name.to_lower() + ".tres").name
	shop_item_desc.text = load("res://shop/resources/" + icon_name.to_lower() + ".tres").description
	shop_item_sprite.texture = load("res://assets/decorations/" + icon_name.to_lower() + ".png")
	shop_item_price_label.text = String(load("res://shop/resources/" + icon_name.to_lower() + ".tres").price)
	shop_anim_player.play("Shake")
	selected = icon_name



func _on_RocksShop_pressed():
	plants_container.visible = false
	rocks_container.visible = true
	hats_container.visible = false
	shop_item_name.text = "rock"
	shop_label.text = "rocks"
	shop_item_desc.text = "rocks for sale"
	shop_anim_player.play("Shake")
	shop_item_sprite.texture = null
	shop_item_price_label.text = "0"
	selected = null
	


func _on_PlantsShop_pressed():
	plants_container.visible = true
	rocks_container.visible = false
	hats_container.visible = false
	shop_item_name.text = "plant"
	shop_label.text = "plants"
	shop_item_desc.text = "buy sum plants"
	shop_anim_player.play("Shake")
	shop_item_sprite.texture = null
	shop_item_price_label.text = "0"
	selected = null


func _on_BuyButton_pressed():
	if selected != null:
		$BookShopButtons/ShopButton.pressed = false
		emit_signal("bought_item", selected)
		


func _on_HatsShop_pressed():
	plants_container.visible = false
	rocks_container.visible = false
	hats_container.visible = true
	shop_item_name.text = "hat"
	shop_label.text = "hats"
	shop_item_desc.text = "hats for fishies"
	shop_anim_player.play("Shake")
	shop_item_sprite.texture = null
	shop_item_price_label.text = "0"
	selected = null
	
