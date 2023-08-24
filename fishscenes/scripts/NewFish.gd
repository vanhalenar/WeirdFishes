extends RigidBody2D

enum{
	SWIM,
	IDLE,
	SIT,
	DRAG
}

onready var sprite = $Sprite
onready var hat_sprite = $Sprite/Hat
onready var hat_detection = $HatDetection

func _ready():
	$AnimationPlayer.play("Idle")
	add_to_group("Fish")

onready var movement_state = IDLE

export var min_speed = 150
export var max_speed = 220
var dir_x
var dir_y
export(float) var swim_time_from = 0.2
export(float) var swim_time_to = 2
export(float) var idle_time_from = 3
export(float) var idle_time_to = 5
export var swim_threshold = 170

var duration = 0.2

onready var tween = $Tween
onready var animation_player = $AnimationPlayer

var chasing = false
var food_location = Vector2.ZERO

func _integrate_forces(state):
	rotation_degrees = 0
	$RayCast2D.cast_to = state.linear_velocity
	
	
	if movement_state == IDLE:
		pass
	elif movement_state == SWIM:
		if (linear_velocity.length() < swim_threshold):
			if chasing:
				dir_x = food_location.x
				dir_y = food_location.y
			else:
				dir_y = rand_range(0, 0.2)*random_sign()
				
				if (global_position.x > 1100):
					dir_x = -pos_x
					$Sprite.flip_h = true
					hat_sprite.position.x = -abs(hat_sprite.position.x)
				elif (global_position.x < 180):
					dir_x = pos_x
					$Sprite.flip_h = false
					hat_sprite.position.x = abs(hat_sprite.position.x)
				
			apply_central_impulse(Vector2(dir_x, dir_y).normalized()*rand_range(min_speed, max_speed))
		
	else:
		pass
		
func random_sign():
	randomize()
	if (rand_range(-1, 1) > 0):
		return 1
	else:
		return -1


var pos_x = 0.0
var pos_y = 0.0


func _on_Timer_timeout():
	randomize()
	match movement_state:
		SWIM:
			$Timer.wait_time = rand_range(swim_time_from, swim_time_to)
			
			chasing = false
			movement_state = IDLE
		IDLE:
			pos_x = rand_range(0, 1)
			pos_y = rand_range(0, 0.5)
			
			if (global_position.x > 1100):
				dir_x = -pos_x
			elif (global_position.x < 180):
				dir_x = pos_x
			else:
				dir_x = pos_x*random_sign()
				
			if (global_position.y > 540):
				dir_y = -pos_y
			elif (global_position.y < 180):
				dir_y = pos_y
			else:
				dir_y = pos_y*random_sign()
			
			$Timer.wait_time = rand_range(idle_time_from, idle_time_to)
			if dir_x > 0:
				$Sprite.flip_h = false
				hat_sprite.position.x = abs(hat_sprite.position.x)
			elif dir_x < 0:
				$Sprite.flip_h = true
				hat_sprite.position.x = -abs(hat_sprite.position.x)
			apply_central_impulse(Vector2(dir_x, dir_y).normalized()*rand_range(min_speed, max_speed))
			movement_state = SWIM


func Hide_Labels():
	$Label.visible = false

func Play_Idle():
	animation_player.play("Idle")

func _on_Fish_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if movement_state != SIT:
				$Label.visible = true
			remove_from_group("Fish")
			get_tree().call_group("Fish", "Hide_Labels")
			add_to_group("Fish")
			animation_player.play("Squash")
			$Timer2.start()


func _on_Timer2_timeout():
	$Label.visible = false


func _on_Area2D_area_entered(area):
	if area.is_in_group("Food"):
		chasing = true
		food_location = area.global_position - global_position
		dir_x = area.global_position.x - global_position.x
		dir_y = area.global_position.y - global_position.y
		if dir_x < 0:
			sprite.flip_h = true
			hat_sprite.position.x = -abs(hat_sprite.position.x)
		elif dir_x > 0:
			sprite.flip_h = false
			hat_sprite.position.x = abs(hat_sprite.position.x)
		apply_central_impulse(Vector2(dir_x, dir_y).normalized()*rand_range(min_speed, max_speed))
		movement_state = SWIM


func _on_Fish_body_entered(body):
	if body.is_in_group("Food"):
		animation_player.play("Squash")
		movement_state = IDLE

func ClearOutline():
	sprite.material = null

func SetOutline():
	sprite.material = load("res://outlinematerial.tres")

func _on_HatDetection_area_exited(area):
	if area.is_in_group("Hats"):
		sprite.material = null

func Dropped(hat_type):
	hat_sprite.texture = load("res://assets/decorations/" + hat_type.to_lower() + ".png")
	hat_sprite.offset = Vector2(-hat_sprite.texture.get_width()/2, -hat_sprite.texture.get_height())
	animation_player.play("Squash")
	
