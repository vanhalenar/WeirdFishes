extends RigidBody2D

func _ready():
	add_to_group("Food")
	$Area2D.add_to_group("Food")

func _on_FoodBit_body_entered(_body):
	queue_free()
