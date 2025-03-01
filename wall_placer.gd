extends Node2D

const _wall_rotation_possible_positions := 12
const _wall_life_time := 10

var _preview_wall : Wall
var _wall_container : Node2D
var _level_camera : Camera2D

var _can_place_wall : bool = true

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
	if (not _can_place_wall):
		return
	
	var new_wall := SC_wall_straight.instantiate()
	new_wall.position = _preview_wall.position
	new_wall.rotation = _preview_wall.rotation
	_wall_container.add_child(new_wall)
	new_wall.get_tree().create_timer(_wall_life_time).timeout.connect(new_wall.initiate_wall_destroy)

func _handle_wall_placeable(is_placeable : bool):
	if (is_placeable):
		_preview_wall.modulate = Color(1,1,1,1)
		_can_place_wall = true
	else:
		_preview_wall.modulate = Color(1,0,0,1)
		_can_place_wall = false
