extends Node2D

const _wall_fadeout_time := 1

var _wall_sprite : Sprite2D
var _wall_collision : StaticBody2D


func _ready() -> void:
	_wall_sprite = get_node("Sprite2D")
	_wall_collision = get_node("StaticBody2D")

func initiate_wall_destroy():
	var tween := get_tree().create_tween()
	
	tween.tween_property(_wall_sprite, "modulate", Color(_wall_sprite.modulate, 0.5), (_wall_fadeout_time / 2.0))
	tween.tween_callback(_wall_collision.queue_free)
	tween.tween_property(_wall_sprite, "modulate", Color(_wall_sprite.modulate, 0), (_wall_fadeout_time / 2.0))
