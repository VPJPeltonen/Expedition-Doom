extends Area2D

var in_work_range = false
var site_in_range

func _process(delta):
	if in_work_range:
		get_parent().in_work_range(site_in_range,delta)

func _on_Work_range_area_entered(area):
	if area.is_in_group("work site"):
		in_work_range = true
		site_in_range = area.get_parent()

func _on_Work_range_area_exited(area):
	if area.is_in_group("work site"):
		in_work_range = false
		site_in_range = null
