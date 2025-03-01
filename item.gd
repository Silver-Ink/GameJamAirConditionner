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
var anim: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim = get_children()[0]
	anim.play(get_spritesheet_name())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
