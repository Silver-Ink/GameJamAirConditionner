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
var destroying: bool = false
var item_scale := 0.0
var sam: SAM
var effects_player: SoundEffects
var before: Before

const item_sounds := {
	Type.APPLE: ["bo-womp", "cartoon-boing", "crunchy-bite"],
	Type.FISH: ["fish", "uiou", "jump", "cartoon_bite_sound_effect"],
	Type.HEART: ["heart-beat", "sparkles", "chime-sparkles"],
	Type.BLOB: ["dégueu", "dégueu2", "crunchy-bite", "dead", "bo-womp"],
	Type.SONIC: ["sonic-spring", "jump", "bongo-feet", "uiou"],
	Type.SQUARE: ["wopi", "dead", "cartoon_sound_effect"]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_children().filter(func(child): return child is Before).front().play("default")
	anim = get_children().filter(func(child): return child is ItemSprite).front()
	anim.play(item_name())
	anim.scale = Vector2(item_scale, item_scale)
	sam = get_children().filter(func(child): return child is SAM).front()
	sam.stream = load("res://assets/sounds/items/%s.wav" % item_name())
	effects_player = get_children().filter(func(child): return child is SoundEffects).front()
	before = get_children().filter(func(child): return child is Before).front()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if appearing:
		if item_scale < 1:
			anim.scale = Vector2(item_scale, item_scale)
			item_scale += 0.15
		else:
			appearing = false
			#sam.play()
			destroy()


func item_name() -> String:
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
	destroying = true
	var possible_sounds: Array = item_sounds[type]
	var chosen = possible_sounds[randi() % possible_sounds.size()]
	if not (chosen == "sparkle" or chosen == "chime-sparkles"):
		effects_player.volume_db += 1
	effects_player.stream = load("res://assets/sounds/items/%s.mp3" % chosen)
	effects_player.play()
	anim.visible = false
	before.play("destroy")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Slime:
		destroy()


func _on_appear_animation_finished() -> void:
	if before.animation == "default":
		anim.visible = true
		appearing = true
	elif before.animation == "destroy":
		anim.visible = false
		before.visible = false
		if not destroying:
			queue_free()


func _on_sound_effects_finished() -> void:
	if not destroying:
		queue_free()
	else:
		destroying = false
