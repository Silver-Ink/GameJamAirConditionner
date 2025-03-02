class_name SurvivingPlayer extends CharacterBody2D


const MAX_SPEED = 300.0
const ACCELERATION = 70.0
const DAMPING = .93

var current_speed := 0.
var rotation_target: float

var explosion_area : Area2D
var _explosion_ready : bool
signal reset_explosion_count

func _ready() -> void:
	explosion_area = get_node("ExplosionArea")
	
	
	reset_explosion_count.connect($"../WallPlacer".reset_explosion_count)
	

func _process(delta: float) -> void:
	
	# Input: handling explosion
	if (Input.is_action_just_pressed("ui_accept") and _explosion_ready):
		_destroy_nearby_walls()
	
	var directionX := Input.get_axis("ui_left", "ui_right")
	var directionY := Input.get_axis("ui_up", "ui_down")
	var direction_vect := Vector2(directionX, directionY).normalized()
	
	
	if direction_vect:
		current_speed += ACCELERATION * delta
		current_speed = clampf(current_speed, 0., MAX_SPEED)
		var directionnal_speed = direction_vect * current_speed
		velocity = directionnal_speed
		
		rotation_target = direction_vect.angle()
		var angle = lerp_angle(rotation, rotation_target, delta*5)
		rotation = angle
			
	else:
		#velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		#velocity.y = move_toward(velocity.y, 0, ACCELERATION)
		velocity *= DAMPING
		current_speed *= DAMPING
		
	
	var collision_info := move_and_collide(velocity * delta)
	if (collision_info):
		#velocity = velocity.bounce(collision_info.get_normal())
		velocity *= DAMPING
		current_speed *= DAMPING
		move_and_slide()

func _destroy_nearby_walls():
	var collide_with_explosion : Array[Node2D] = explosion_area.get_overlapping_bodies()
	collide_with_explosion = collide_with_explosion.filter(func(node : Node2D) : return node is RigidBody2D)
	
	for wall in collide_with_explosion:
		wall.get_parent().queue_free()
		
	_explosion_ready = false
	reset_explosion_count.emit()
	
	$"../GameBackground".wall_counter = 0
	


func _on_walls_placed_progression(count: int) -> void:
	$"../GameBackground".wall_counter += 1
	if (count == WallPlacer.walls_progression_max):
		_explosion_ready = true
