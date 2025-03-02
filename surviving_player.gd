class_name SurvivingPlayer extends CharacterBody2D


const MAX_SPEED = 300.0
const ACCELERATION = 70.0
const DAMPING = .93

var current_speed := 0.
var rotation_target: float

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:

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
		
