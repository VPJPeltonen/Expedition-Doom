extends AnimatedSprite

export (PackedScene) var Blood_splatter
export (PackedScene) var Corpse

var rng = RandomNumberGenerator.new()
var health = 1
var state 

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	frame = rng.randi_range(0,1)

func damage(damage_done):
	var b = Blood_splatter.instance() 
	get_parent().get_parent().get_parent().get_parent().add_child(b)
	b.global_position = global_position
	health -= damage_done
	if health <= 0:
		var c = Corpse.instance() 
		get_parent().get_parent().get_parent().get_parent().add_child(c)
		c.global_position = global_position
		queue_free()
		
func change_state(new_state):
	state = new_state
	set_animation(new_state)
