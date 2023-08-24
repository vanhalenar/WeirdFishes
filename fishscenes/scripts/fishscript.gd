extends KinematicBody2D

export(int) var ACCELERATION = 1400
#export(float) var MIN_SPEED = 100
export(int) var MAX_SPEED = 200
export(int) var FRICTION = 80
export(float) var idle_time_from = 2
export(float) var idle_time_to = 5
export(float) var swim_time_from = 0
export(float) var swim_time_to = 1


var move_vector = Vector2.ZERO

var direction = Vector2()

var velocity = Vector2()

onready var tween = $Tween

var squeeze_value = 1.3

var squeeze_time = 0.15

onready var fish_sprite = $Sprite

onready var fish_scale_x = scale.x

onready var fish_scale_y = scale.y

enum{
	IDLE,
	SWIM,
	SIT,
	DRAG
}

var state = SWIM

func _ready():
	add_to_group("Fish")
	var label = get_tree().get_root().get_node("Aquarium/UserInterface/FishBook/ScrollContainer/GridContainer/" + name + "/Label")
	label.text = name.to_lower()
	label.get_parent().texture_normal = load("res://assets/portraits/" + name.to_lower() + "portrait.png")
	$AnimationPlayer.play("Idle")

func _physics_process(delta):

	match state:
		SWIM:
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		SIT:
			pass
		DRAG:
			var current_position : Vector2 = self.global_position
			var mouse_position : Vector2 = get_global_mouse_position()
			var distance : float = clamp(current_position.distance_to(mouse_position), 0, 20)
			direction = current_position.direction_to(mouse_position)
			var speed : float = distance / delta
			velocity = direction * speed

	#print(velocity)
	velocity = move_and_slide(velocity)
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			direction = direction.bounce(collision.normal)
			state = IDLE


func _on_Timer_timeout():
	randomize()
	if state == SWIM:
		state = IDLE
		$Timer.wait_time = rand_range(swim_time_from, swim_time_to)
		$Particles2D.emitting = false
	elif state == IDLE:
		state = SWIM
		$Timer.wait_time = rand_range(idle_time_from, idle_time_to)
		$Particles2D.emitting = true
		
	
		

		direction = Vector2(rand_range(-1, 1), rand_range(-0.5, 0.5))
		
		if direction.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	
		velocity = velocity.normalized()
		direction = direction.normalized()

		$Particles2D.process_material.direction.x = -direction.x
		$Particles2D.process_material.direction.y = -direction.y

func hide_labels():
	$Label.visible = false

func _on_Fish_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			state = DRAG
			if state != SIT:
				$Label.visible = true
			remove_from_group("Fish")
			get_tree().call_group("Fish", "hide_labels")
			add_to_group("Fish")
			
			
			tween.interpolate_property(
				self, 
				"scale", 
				Vector2(fish_scale_x, fish_scale_y), 
				Vector2(fish_scale_x, fish_scale_y/squeeze_value), 
				0.07, 
				Tween.TRANS_SINE, 
				Tween.EASE_OUT_IN)
			tween.start()
			
			yield(tween, "tween_completed")
			
			tween.interpolate_property(
				self, 
				"scale", 
				Vector2(fish_scale_x, fish_scale_y), 
				Vector2(fish_scale_x, fish_scale_y), 
				0.2, 
				Tween.TRANS_SINE, 
				Tween.EASE_OUT_IN)
			tween.start()
		else:
			state = IDLE
