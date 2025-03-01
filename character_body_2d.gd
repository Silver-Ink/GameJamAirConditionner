extends CharacterBody2D


const MAX_SPEED = 300.0
const ACCELERATION = 400.0
const PARTICLE_SPEED_RATIO = .7
const DAMPING = .93
@export_range(.1, 4., .1) var particle_damp_factor = 2.

var current_speed := 0.
var front_join_dist : float
var lst_particle: Array[RigidBody2D]
var rotation_target: float

@onready var soft_body_detector: Area2D = $SoftBodyDetector
@onready var front_join: PinJoint2D = $FrontJoin
@onready var soft_body: SoftBody2D = $"../SoftBody2D"

func _ready() -> void:
	get_tree().create_timer(.1, true, true).timeout.connect(disable_softbody_detector)
	front_join_dist = global_position.distance_to(front_join.global_position)

func disable_softbody_detector():
	soft_body_detector.queue_free()
	soft_body_detector = null
	print(lst_particle.size())
	

func _physics_process(delta: float) -> void:

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
		#soft_body.rotation = angle
		#soft_body.constant_torque = angle
		
		for particle in lst_particle:
			particle.linear_velocity = \
			directionnal_speed * PARTICLE_SPEED_RATIO + \
			particle.linear_velocity *(1-PARTICLE_SPEED_RATIO)
			
	else:
		velocity *= DAMPING
		for particle in lst_particle:
			var dist_from_center = particle.global_position.distance_to(global_position)
			
			var dist_scaled = dist_from_center * .1
			
			var particle_damp = \
							1. /  						\
			(particle_damp_factor * dist_from_center + 1)
			
			particle.linear_velocity *= particle_damp

	move_and_slide()


func _on_soft_body_detector_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		lst_particle.append(body)
