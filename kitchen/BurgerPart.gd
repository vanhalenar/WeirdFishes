extends RigidBody2D

signal clicked

signal spawn_part(part_name, pos)

signal first_dropped()

signal first_impact()

export (String) var my_name

export (int) var my_value

var held = false

onready var eligible = false

onready var first_pickup = false

onready var first_drop = false

onready var first_collision = false

func _physics_process(_delta):
	if held:
		global_transform.origin = get_global_mouse_position()

func pickup():
	if held:
		return
	mode = RigidBody2D.MODE_STATIC
	held = true
	if first_pickup == false:
		emit_signal("spawn_part", my_name, global_position)
		$Sprite.scale = Vector2(8, 8)
		$Area2D.scale = Vector2(1, 1)
		$CollisionShape2D.disabled = false
		first_pickup = true
		

func drop(impulse=Vector2.ZERO):
	if held:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse*10)
		held = false
		if first_drop == false:
			first_drop = true
			emit_signal("first_dropped")

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)

func _on_Part_body_entered(_body):
	if !held:
		if first_collision == false:
			emit_signal("first_impact")
			first_collision = true
