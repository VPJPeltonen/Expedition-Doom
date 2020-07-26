extends Area2D

func _on_Area2D_area_entered(area):
	if area.is_in_group("thing"):
		area.get_parent().lights_in_range.append(self)

func _on_Area2D_area_exited(area):
	if area.is_in_group("thing"):
		if area.get_parent().lights_in_range.has(self):
			area.get_parent().lights_in_range.erase(self)
