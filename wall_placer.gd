extends Node2D

const _wall_rotation_possible_positions := 12
const _wall_life_time := 10
const _wall_place_cooldown := 2

var _preview_wall : Wall
var _wall_container : Node2D
var _level_camera : Camera2D

var _can_place_wall : bool = true
var _is_place_in_cooldown : bool = false

var SC_wall_straight := preload("res://WallStraight.tscn")

func _ready() -> void:
	_preview_wall = SC_wall_straight.instantiate()
	add_child(_preview_wall)
	_preview_wall.set_to_preview_mode()
	_preview_wall.wall_placeable_status.connect(_handle_wall_placeable)
	
	_wall_container = get_node("WallContainer")
	
	_level_camera = get_node("../Camera2D")
	assert(_level_camera, "Error: level camera not found")


func _process(_delta: float) -> void:
	# Following mouse
	_preview_wall.position = _level_camera.get_global_mouse_position() - position
	
	# Handling input: wall placing
	if (Input.is_action_just_pressed("place_wall")):
		_place_wall()
	
	# Handling input: wall rotating
	var rotate_preview_direction := 0
	if (Input.is_action_just_pressed("rotate_wall_left")):
		rotate_preview_direction = -1
	if (Input.is_action_just_pressed("rotate_wall_right")):
		rotate_preview_direction = 1
	
	if (rotate_preview_direction):
		_preview_wall.rotation += rotate_preview_direction * ((2*PI) / _wall_rotation_possible_positions)

func _place_wall():
	if ((not _can_place_wall) or _is_place_in_cooldown):
		return
	
	# Create wall instance
	var new_wall := SC_wall_straight.instantiate()
	new_wall.position = _preview_wall.position
	new_wall.rotation = _preview_wall.rotation
	new_wall.get_node("RigidBody2D/Area2D/PreviewCollisionShape2D").set_deferred("disabled", true)
	_wall_container.add_child(new_wall)
	new_wall.get_tree().create_timer(_wall_life_time).timeout.connect(new_wall.initiate_wall_destroy)
	
	# Initiate cooldown on wall place
	_handle_placing_cooldown(true)
	get_tree().create_timer(_wall_place_cooldown).timeout.connect(_handle_placing_cooldown.bind(false))

func _handle_wall_placeable(is_placeable : bool):
	_can_place_wall = is_placeable
	
	if (_is_place_in_cooldown):
		return # Cooldown effects override impossible placement effects
		
	if (is_placeable):
		_preview_wall.modulate = Color(1,1,1,1)
		_can_place_wall = true
	else:
		_preview_wall.modulate = Color(1,0,0,1)
		_can_place_wall = false

func _handle_placing_cooldown(is_in_cooldown : bool):
	_is_place_in_cooldown = is_in_cooldown
	
	if (is_in_cooldown):
		_preview_wall.modulate = Color(1,1,0,1)
	else:
		_handle_wall_placeable(_can_place_wall) # If there's no cooldown, check if there's impossible placement
