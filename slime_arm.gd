extends RigidBody2D


const MIN_DIST_TO_NAVIGATE = 30.

var next_point_dest : Vector2

@export var pos_to_follow : Node2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dist_to_dest = pos_to_follow.global_position.distance_to(global_position)
	if (dist_to_dest > MIN_DIST_TO_NAVIGATE):
		nav_agent.target_position = pos_to_follow.position
		next_point_dest = nav_agent.get_next_path_position()
		
	if (dist_to_dest > 5.):
		var direction = (global_position - next_point_dest).normalized()
		linear_velocity += direction
	
