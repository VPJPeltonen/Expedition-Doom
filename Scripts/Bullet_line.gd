extends Line2D

var alpha = 1

func _process(delta):
	alpha -= delta * 2
	default_color = Color(1,0.5,0,alpha)
		
func show_line(path):
	points = path
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
