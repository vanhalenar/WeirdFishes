extends Area2D


#signal Let_Go(hat_type)

var hat_target

var overlap

func Explode():
	if get_overlapping_areas():
		hat_target = get_overlapping_areas().back()
	# warning-ignore:return_value_discarded
		hat_target.get_parent().Dropped(get_parent().name)
		#connect("Let_Go", hat_target.get_parent(), "Dropped")
		#emit_signal("Let_Go", get_parent().name)
		#disconnect("Let_Go", hat_target.get_parent(), "Dropped")
		get_parent().queue_free()
	

func UpdateOutlines():
	if get_overlapping_areas():
		overlap = get_overlapping_areas()
		overlap.back().get_parent().SetOutline()
		for i in range(0, overlap.size()-1):
			overlap[i].get_parent().ClearOutline()

func _on_Area2D_area_entered(_area):
	UpdateOutlines()

func _on_Area2D_area_exited(_area):
	UpdateOutlines()
