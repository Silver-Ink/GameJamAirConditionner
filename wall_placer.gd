extends Node2D

const wall_rotation_possible_positions := 20
const wall_life_time := 10

var preview_sprite : Sprite2D
var wall_container : Node2D

var SC_wall_straight := preload("res://WallStraight.tscn")

func _ready() -> void:
	preview_sprite = get_node("WallPreviewSprite")
	wall_container = get_node("WallContainer")


func _process(_delta: float) -> void:
	# Following mouse
	preview_sprite.position = get_viewport().get_mouse_position() - position
	
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
		preview_sprite.rotation += rotate_preview_direction * ((2*PI) / wall_rotation_possible_positions)

func _place_wall():
	var new_wall := SC_wall_straight.instantiate()
	new_wall.position = preview_sprite.position
	new_wall.rotation = preview_sprite.rotation
	wall_container.add_child(new_wall)
	new_wall.get_tree().create_timer(wall_life_time).timeout.connect(new_wall.initiate_wall_destroy)
