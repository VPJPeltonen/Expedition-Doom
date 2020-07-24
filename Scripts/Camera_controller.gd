extends Camera2D

export var camera_speed = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("camera_up"):
		direction.y -= camera_speed
	elif Input.is_action_pressed("camera_down"):
		direction.y += camera_speed
	
	if Input.is_action_pressed("camera_left"):
		direction.x -= camera_speed
	elif Input.is_action_pressed("camera_right"):
		direction.x += camera_speed
	position += direction
