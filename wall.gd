class_name Wall extends Node2D

const _wall_fadeout_time := 1

var _wall_sprite : Sprite2D
var _wall_collision : RigidBody2D

var _nb_bodies_on_preview_shape : int = 0

signal wall_placeable_status ( placeable : bool )

func _ready() -> void:
	_wall_sprite = get_node("Sprite2D")
	_wall_collision = get_node("RigidBody2D")

func initiate_wall_destroy():
	var tween := get_tree().create_tween()
	
	tween.tween_property(_wall_sprite, "modulate", Color(_wall_sprite.modulate, 0.5), (_wall_fadeout_time / 2.0))
	tween.tween_callback(_wall_collision.queue_free)
	tween.tween_property(_wall_sprite, "modulate", Color(_wall_sprite.modulate, 0), (_wall_fadeout_time / 2.0))

func set_to_preview_mode():
	var collision : CollisionShape2D = _wall_collision.get_node("CollisionShape2D")
	collision.set_deferred("disabled", true)
	
	_wall_sprite.modulate.a = 0.3

func _on_preview_shape_body_entered(body: Node2D) -> void:
	if (body == get_node("../../WorldCollisionStaticBody")):
		return # Ignore level border
	
	wall_placeable_status.emit(false)
	_nb_bodies_on_preview_shape += 1

func _on_preview_shape_body_exited(body: Node2D) -> void:
	if (body == get_node("../../WorldCollisionStaticBody")):
		return # Ignore level border
		
	_nb_bodies_on_preview_shape -= 1
	if (_nb_bodies_on_preview_shape == 0):
		wall_placeable_status.emit(true)
