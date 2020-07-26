extends Node2D

export (PackedScene) var Blood_splatter
export (PackedScene) var Corpse

onready var pathfinding = get_parent().get_parent()

var health = 3
var attack_power = 1
var state
var target
var current_target
var speed = 100.0
var path = PoolVector2Array() setget set_path
var attack_ready = true
var lights_in_range = []

func _ready():
	$Path_timer.set_wait_time(get_parent().rng.randf_range(0.3,0.6))
	change_state("default")

func _process(delta):
	match state: 
		"default":
			target = get_parent().get_closest_target(self)
			if target == null:
				print("no target")
				return
			var new_path = pathfinding.get_AI_path(self,target)
			set_path(new_path)
			change_state("walk")
		"walk":
			var move_distance = speed * delta
			move_along_path(move_distance)
		"attack":
			attack()
	
func attack():
	if !attack_ready:
		return
	if current_target == null:
		change_state("default")
		return
	current_target.damage(attack_power)
	attack_ready = false
	$Reload_timer.start()
			
func move_along_path(dist):
	if path.size() == 0:
		change_state("default")
		return
	if path[0].x < global_position.x:
		$Monster_sprite.scale.x = 1
	else:
		$Monster_sprite.scale.x = -1
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if dist <= distance_to_next and dist >= 0.0:
			position = start_point.linear_interpolate(path[0],dist / distance_to_next)
			break
		elif dist < 0.0:
			position = path[0]
			break
		dist -= distance_to_next
		start_point = path[0]
		path.remove(0)
				
func damage(damage_done):
	var b = Blood_splatter.instance() 
	get_parent().add_child(b)
	b.global_position = global_position
	if !lights_in_range.empty():
		damage_done += damage_done
	print(damage_done)
	health -= damage_done
	if health <= 0:
		$DeathSound.play()
		change_state("die")

func set_path(value):
	path = value
	if value.size() == 0:
		return

func enemy_in_range(enemy):
	current_target = enemy
	if state == "default":
		change_state("attack")

func change_state(new_state):
	state = new_state
	$Monster_sprite.set_animation(new_state)

func _on_Monster_sprite_animation_finished():
	if state == "die":
		get_parent().enemy_died(self)
		var c = Corpse.instance() 
		get_parent().get_parent().get_parent().get_parent().add_child(c)
		c.global_position = global_position
		queue_free()

func _on_Reload_timer_timeout():
	attack_ready = true


func _on_Path_timer_timeout():
	target = get_parent().get_closest_target(self)
	if target == null:
		print("no target")
		return
	var new_path = pathfinding.get_AI_path(self,target)
	set_path(new_path)
