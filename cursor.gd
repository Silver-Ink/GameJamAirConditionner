class_name Cursor extends Node2D

var cursor_sprite : Sprite2D

var regular_sprite : Texture2D
var illegal_sprite : Texture2D
var dead_sprite : Texture2D

func _ready() -> void:
	cursor_sprite = get_node("Sprite2D")
	
	regular_sprite = load("res://assets/cursors/cursor.png")
	illegal_sprite = load("res://assets/cursors/cursor_illegal.png")
	dead_sprite = load("res://assets/cursors/cursor_dead.png")

func set_to_regular():
	cursor_sprite.set_texture(regular_sprite)
	
func set_to_illegal():
	cursor_sprite.set_texture(illegal_sprite)
	
func set_to_dead():
	cursor_sprite.set_texture(dead_sprite)
