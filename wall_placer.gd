extends Node2D

const _wall_rotation_possible_positions := 20
const _wall_life_time := 10

var _preview_sprite : Sprite2D
var _wall_container : Node2D
var _level_camera : Camera2D

var SC_wall_straight := preload("res://WallStraight.tscn")

func _ready() -> void:
	_preview_sprite = get_node("WallPreviewSprite")
	_wall_container = get_node("WallContainer")
	
	_level_camera = get_node("../Camera2D")
	assert(_level_camera, "Error: level camera not found")


func _process(_delta: float) -> void:
	# Following mouse
	_preview_sprite.position = _level_camera.get_global_mouse_position() - position
	
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
		_preview_sprite.rotation += rotate_preview_direction * ((2*PI) / _wall_rotation_possible_positions)

func _place_wall():
	var new_wall := SC_wall_straight.instantiate()
	new_wall.position = _preview_sprite.position
	new_wall.rotation = _preview_sprite.rotation
	_wall_container.add_child(new_wall)
	new_wall.get_tree().create_timer(_wall_life_time).timeout.connect(new_wall.initiate_wall_destroy)
