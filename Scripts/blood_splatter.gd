extends AnimatedSprite

export var human = true
var alpha = 1

func _ready():
	play()

func _process(delta):
	alpha -= delta
	if human:
		set_modulate(Color(1,0,0,alpha))
	else:
		set_modulate(Color(0,1,0,alpha))

func _on_blood_splatter_animation_finished():
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
