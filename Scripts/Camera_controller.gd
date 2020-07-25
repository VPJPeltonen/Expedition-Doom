extends Camera2D

export var camera_speed = 10
var negative_limits = Vector2(-230,-260)
var positive_limits = Vector2(2470,2820)

func _process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("camera_up") and position.y > negative_limits.y:
		direction.y -= camera_speed
	elif Input.is_action_pressed("camera_down") and position.y < positive_limits.y:
		direction.y += camera_speed
	
	if Input.is_action_pressed("camera_left") and position.x > negative_limits.x:
		direction.x -= camera_speed
	elif Input.is_action_pressed("camera_right") and position.x < positive_limits.x:
		direction.x += camera_speed
	position += direction
