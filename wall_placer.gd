class_name WallPlacer extends Node2D

const _wall_rotation_possible_positions := 12
const _wall_life_time := 10
const _wall_place_cooldown := 1

const soundbank = [
	"scratch1",
	"scratch2"
]

var _cursor : Cursor
var _preview_wall : Wall
var _wall_container : Node2D
var _effects_player: AudioStreamPlayer
var _level_camera : Camera2D

var _can_place_wall : bool = true
var _is_place_in_cooldown : bool = false

var is_choice_1 := true
var wall_type_choice_1 : GE.WallType
var wall_type_choice_2 : GE.WallType
var _current_wall_type : GE.WallType

var walls_placed_count := 0
signal walls_placed_progression ( count : int )
const walls_progression_max := 5

var SC_wall_straight := preload("res://WallStraight.tscn")
var SC_wall_dirac := preload("res://WallDirac.tscn")
var SC_wall_tilde := preload("res://WallTilde.tscn")
var SC_wall_u := preload("res://WallU.tscn")
var SC_wall_wide_u := preload("res://WallWideU.tscn")
var SC_new_wall : PackedScene

var SC_cursor := preload("res://Cursor.tscn")

func _ready() -> void:
	# Set random walls
	var rand := randi() % (GE.WallType.size()-1)
	wall_type_choice_1 = rand
	wall_type_choice_2 = rand + 1
	_current_wall_type = wall_type_choice_1
	
	
	# Hide real cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	_cursor = SC_cursor.instantiate()
	add_child(_cursor)
	
	_wall_container = get_node("WallContainer")
	_effects_player = get_node("EffectsPlayer")
	
	# Generating wall preview
	_change_wall_type(wall_type_choice_1)
	
	_level_camera = get_node("../Camera2D")
	assert(_level_camera, "Error: level camera not found")


func _process(_delta: float) -> void:
	# Following mouse
	var mouse_position = _level_camera.get_global_mouse_position() - position
	_preview_wall.position = mouse_position
	_cursor.position = mouse_position
	
	
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
	
	# Handling input: wall type switch
	if (Input.is_action_just_pressed("switch_wall_type")):
		_switch_wall_type()

func _place_wall():
	if ((not _can_place_wall) or _is_place_in_cooldown):
		return
	
	# Create wall instance
	var new_wall := SC_new_wall.instantiate()
	new_wall.position = _preview_wall.position
	new_wall.rotation = _preview_wall.rotation
	new_wall.get_node("RigidBody2D/Area2D/PreviewCollision").set_deferred("disabled", true)
	_wall_container.add_child(new_wall)
	
	_effects_player.stream = load("res://assets/sounds/walls/%s.mp3" % soundbank[randi() % soundbank.size()])
	_effects_player.play()
	
	new_wall.get_tree().create_timer(_wall_life_time).timeout.connect(new_wall.initiate_wall_destroy)
	
	# Initiate cooldown on wall place
	_handle_placing_cooldown(true)
	get_tree().create_timer(_wall_place_cooldown).timeout.connect(_handle_placing_cooldown.bind(false))
	
	# Updating count
	if (walls_placed_count < walls_progression_max):
		walls_placed_count += 1
		print(walls_placed_count)
		walls_placed_progression.emit(walls_placed_count)


func _handle_wall_placeable(is_placeable : bool):
	_can_place_wall = is_placeable
	
	if (_is_place_in_cooldown):
		return # Cooldown effects override impossible placement effects
		
	if (is_placeable):
		_preview_wall.modulate = Color(1,1,1,1)
		_cursor.set_to_regular()
		_can_place_wall = true
	else:
		_preview_wall.modulate = Color(1,0,0,1)
		_cursor.set_to_illegal()
		_can_place_wall = false

func _handle_placing_cooldown(is_in_cooldown : bool):
	_is_place_in_cooldown = is_in_cooldown
	
	if (is_in_cooldown):
		_preview_wall.modulate = Color(1,1,0,1)
		_cursor.set_to_dead()
	else:
		_handle_wall_placeable(_can_place_wall) # If there's no cooldown, check if there's impossible placement

func _change_wall_type(type : GE.WallType):
	if (_preview_wall and type == _current_wall_type):
		return # Don't recreate if it's the same wall type
		
	# Getting correct wall scene
	match type:
		GE.WallType.DIRAC:
			SC_new_wall = SC_wall_dirac
		GE.WallType.STRAIGHT:
			SC_new_wall = SC_wall_straight
		GE.WallType.TILDE:
			SC_new_wall = SC_wall_tilde
		GE.WallType.U:
			SC_new_wall = SC_wall_u
		GE.WallType.WIDE_U:
			SC_new_wall = SC_wall_wide_u
	
	var preview_rotation := 0.0
	
	if (_preview_wall):
		# Conserving preview rotation
		preview_rotation = _preview_wall.rotation
		
		_preview_wall.queue_free()
	
	_current_wall_type = type
	
	# Creating new preview wall
	_preview_wall = SC_new_wall.instantiate()
	_preview_wall.rotation = preview_rotation
	add_child(_preview_wall)
	_preview_wall.set_to_preview_mode()
	_preview_wall.wall_placeable_status.connect(_handle_wall_placeable)

func _switch_wall_type():
	if (is_choice_1):
		_change_wall_type(wall_type_choice_2)
	else:
		_change_wall_type(wall_type_choice_1)
	is_choice_1 = not is_choice_1


func reset_explosion_count() -> void:
	walls_placed_count = 0
