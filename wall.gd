class_name Wall extends Node2D

const _wall_fadeout_time := 1

var _wall_sprite : Sprite2D
var _wall_collision : RigidBody2D

var _nb_bodies_on_preview_shape : int = 0

signal wall_placeable_status ( placeable : bool )


func _ready() -> void:
	_wall_sprite = get_node("Sprite2D")
	_wall_collision = get_node("RigidBody2D")
	
	$RigidBody2D/Area2D.body_entered.connect(_on_preview_shape_body_entered)
	$RigidBody2D/Area2D.body_exited.connect(_on_preview_shape_body_exited)
	$RigidBody2D/Area2D.area_entered.connect(_on_preview_shape_body_entered)
	$RigidBody2D/Area2D.area_exited.connect(_on_preview_shape_body_exited)

func initiate_wall_destroy():
	var tween := get_tree().create_tween()
	
	tween.tween_property(_wall_sprite, "modulate", Color(_wall_sprite.modulate, 0.5), (_wall_fadeout_time / 2.0))
	tween.tween_callback(_wall_collision.queue_free)
	tween.tween_property(_wall_sprite, "modulate", Color(_wall_sprite.modulate, 0), (_wall_fadeout_time / 2.0))

func set_to_preview_mode():
	var collision : CollisionPolygon2D = _wall_collision.get_node("RegularCollision")
	collision.set_deferred("disabled", true)
	
	_wall_sprite.modulate.a = 0.3
	_wall_sprite.set_z_index(3500)

func _on_preview_shape_body_entered(body: Node2D) -> void:
	if (body == get_node("../../WorldCollisionStaticBody") or body == get_node("../../SurvivingPlayer/").explosion_area):
		return # Ignore level border and player collision area
	
	wall_placeable_status.emit(false)
	_nb_bodies_on_preview_shape += 1

func _on_preview_shape_body_exited(body: Node2D) -> void:
	if (body == get_node("../../WorldCollisionStaticBody") or body == get_node("../../SurvivingPlayer/").explosion_area):
		return # Ignore level border and player collision area
		
	_nb_bodies_on_preview_shape -= 1
	if (_nb_bodies_on_preview_shape == 0):
		wall_placeable_status.emit(true)
