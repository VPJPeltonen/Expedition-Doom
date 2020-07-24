extends Area2D

var things_in_range = []

func _process(delta):
	if things_in_range.size() > 0:
		get_parent().enemy_in_range(things_in_range.front())

func _on_Attack_range_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group("crew"):
		if !things_in_range.has(area.get_parent()):
			things_in_range.append(area.get_parent())
			print("enemy found")

func _on_Attack_range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area == null:
		return
	if area.is_in_group("crew"):
		if things_in_range.has(area.get_parent()):
			things_in_range.erase(area.get_parent())
