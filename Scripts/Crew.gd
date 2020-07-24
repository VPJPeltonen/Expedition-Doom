extends Node2D

export (PackedScene) var Bullet_line

var speed = 200.0
var path = PoolVector2Array() setget set_path
var state = "default"
var current_target
var shot_ready = true
var health = 3

func _ready():
	change_state("default")

func _process(delta):
	match state:
		"default":
			pass
		"walk":
			var move_distance = speed * delta
			move_along_path(move_distance)
		"shoot":
			shoot()

func shoot():
	if !shot_ready or current_target == null:
		return
		
	var bulletpath = PoolVector2Array()
	if $Crew_sprite.scale.x == 1:
		bulletpath.append(Vector2(-6,-1.5))
	else:
		bulletpath.append(Vector2(6,-1.5))
	bulletpath.append(current_target.global_position - global_position)
	
	var b = Bullet_line.instance() 
	get_parent().add_child(b)
	b.global_position = global_position
	b.show_line(bulletpath)
	
	current_target.damage(0)
	shot_ready = false
	$Reload_timer.start()

func move_along_path(dist):
	if path.size() == 0:
		change_state("default")
		return
	if path[0].x < global_position.x:
		$Crew_sprite.scale.x = 1
	else:
		$Crew_sprite.scale.x = -1
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
		
func set_path(value):
	path = value
	if value.size() == 0:
		return
	change_state("walk")
	
func change_state(new_state):
	state = new_state
	$Crew_sprite.set_animation(new_state)

func enemy_in_range(enemy):
	current_target = enemy
	if state == "default":
		change_state("shoot")
		
func damage(damage_done):
	health -= damage_done
	if health <= 0:
		change_state("die")
		
func select(selected):
	if selected:
		$Select_Sprite.show()
	else:
		$Select_Sprite.hide()

func _on_Reload_timer_timeout():
	shot_ready = true

func _on_Enemies_enemy_dead(enemy):
	if enemy == current_target:
		current_target = null
	$Attack_range.target_killed(enemy)

func _on_Body_area_input_event(viewport, event, shape_idx):
	if !event.is_pressed():
		return
	if event.button_index != BUTTON_LEFT:
		get_parent().set_selected_character(self)

func _on_Crew_sprite_animation_finished():
	if state == "die":
		get_parent().crewman_dead(self)
		queue_free()
