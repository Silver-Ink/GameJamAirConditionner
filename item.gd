extends Node2D

enum Type {
	APPLE,
	FISH,
	HEART,
	BLOB,
	SONIC,
	SQUARE,
	TRASH
}

@export var type: Type
var anim: ItemSprite
var appearing: bool = false
var item_scale := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_children().filter(func(child): return child is Before).front().play("default")
	anim = get_children().filter(func(child): return child is ItemSprite).front()
	anim.play(get_spritesheet_name())
	anim.scale = Vector2(item_scale, item_scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if appearing:
		if item_scale < 1:
			anim.scale = Vector2(item_scale, item_scale)
			item_scale += 0.15
		else:
			appearing = false


func get_spritesheet_name() -> String:
	match type:
		Type.APPLE:
			return "apple"
		Type.FISH:
			return "fish"
		Type.HEART:
			return "heart"
		Type.BLOB:
			return "slimte"
		Type.SONIC:
			return "sonic"
		Type.SQUARE:
			return "square guy"
		Type.TRASH:
			return "transh"
		_:
			push_error("Unknown item type")
			return ""


func destroy():
	anim.play("destroy")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Slime:
		destroy()


func _on_appear_animation_finished() -> void:
	anim.visible = true
	appearing = true
