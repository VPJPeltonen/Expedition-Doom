extends Node2D

export (PackedScene) var Blood_splatter

onready var pathfinding = get_parent().get_parent()

var health = 3
var state
var target
var current_target
var speed = 150.0
var path = PoolVector2Array() setget set_path
var attack_ready = true

func _ready():
	change_state("default")

func _process(delta):
	match state: 
		"default":
			target = get_parent().get_closest_target(self)
			if target == null:
				return
			var new_path = pathfinding.get_AI_path(self,target)
			set_path(new_path)
			change_state("walk")
		"walk":
			#var path = pathfinding.get_AI_path(self,target)
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
	#var bulletpath = PoolVector2Array()
	#if $Crew_sprite.scale.x == 1:
	#	bulletpath.append(Vector2(-6,-1.5))
	#else:
	#	bulletpath.append(Vector2(6,-1.5))
	#bulletpath.append(current_target.global_position - global_position)
	
	#var b = Bullet_line.instance() 
	#get_parent().add_child(b)
	#b.global_position = global_position
	#b.show_line(bulletpath)
	
	current_target.damage(1)
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
	health -= damage_done
	if health <= 0:
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
		queue_free()

func _on_Reload_timer_timeout():
	attack_ready = true

