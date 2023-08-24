extends StaticBody2D

onready var sprite = $Sprite

onready var anim_player = $AnimationPlayer

var drag = true

var GRID_SIZE = 16.0

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.doubleclick:
		print("doubleclicked")
		select()
		
func _unhandled_input(event: InputEvent):
	if drag:
		if event is InputEventScreenDrag:
			var mouse_pos: Vector2 = get_global_mouse_position()
			global_position = Vector2(stepify(mouse_pos.x, GRID_SIZE), stepify(mouse_pos.y, GRID_SIZE))



func _on_Rotate_pressed():
	$Tween.interpolate_property(
		$Sprite, 
		"rotation_degrees", 
		null,
		$Sprite.rotation_degrees+90, 
		0.4,
		Tween.TRANS_BACK)
	$CollisionShape2D.rotation_degrees += 90
	$Area2D/CollisionShape2D.rotation_degrees += 90
	$Tween.start()
	


func _on_Mirror_pressed():
	$Tween.interpolate_property(
		$Sprite, 
		"scale", 
		null,
		Vector2($Sprite.scale.x * -1, $Sprite.scale.y), 
		0.4,
		Tween.TRANS_BACK)

	$Tween.start()


func _on_Place_pressed():
	unselect()


func _on_Sell_pressed():
	queue_free()
	
func select():
	anim_player.play("SwoopIn")
	sprite.material = load("res://outlinematerial.tres")
	drag = true
	
func unselect():
	anim_player.play("SwoopOut")
	sprite.material = null
	drag = false
