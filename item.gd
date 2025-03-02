class_name Item extends Node2D

enum ItemType {
	APPLE = 0,
	FISH = 1,
	HEART = 2,
	BLOB = 3,
	SONIC = 4,
	SQUARE = 5,
	TRASH = 6,
	COUNT = 7
}

@export var item_type: ItemType
var anim: ItemSprite
var appearing: bool = false
var destroying: bool = false
var item_scale := 0.001
var sam: SAM
var effects_player: SoundEffects
var before: Before

const item_sounds := {
	ItemType.APPLE: ["bo-womp", "cartoon-boing", "crunchy-bite"],
	ItemType.FISH: ["fish", "uiou", "jump", "cartoon_bite_sound_effect"],
	ItemType.HEART: ["heart-beat", "sparkles", "chime-sparkles"],
	ItemType.BLOB: ["dégueu", "dégueu2", "crunchy-bite", "dead", "bo-womp"],
	ItemType.SONIC: ["sonic-spring", "jump", "bongo-feet", "uiou"],
	ItemType.SQUARE: ["wopi", "dead", "cartoon_sound_effect", "metal-pipe", "ou", "fart"],
	ItemType.TRASH: ["fish"] # TEMPTEMPTEMP
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_children().filter(func(child): return child is Before).front().play("default")
	anim = get_children().filter(func(child): return child is ItemSprite).front()
	anim.scale = Vector2(item_scale, item_scale)
	sam = get_children().filter(func(child): return child is SAM).front()
	sam.stream = load("res://assets/sounds/items/%s.wav" % item_name())
	effects_player = get_children().filter(func(child): return child is SoundEffects).front()
	before = get_children().filter(func(child): return child is Before).front()
	init()

func init():
	var type = randi() % ItemType.COUNT
	item_type = type
	anim.play(item_name())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if appearing:
		if item_scale < 1:
			anim.scale = Vector2(item_scale, item_scale)
			item_scale += delta * 4.
		else:
			appearing = false
			#sam.play()


func item_name() -> String:
	match item_type:
		ItemType.APPLE:
			return "apple"
		ItemType.FISH:
			return "fish"
		ItemType.HEART:
			return "heart"
		ItemType.BLOB:
			return "slimte"
		ItemType.SONIC:
			return "sonic"
		ItemType.SQUARE:
			return "square guy"
		ItemType.TRASH:
			return "transh"
		_:
			push_error("Unknown item ItemType")
			return ""


func destroy():
	destroying = true
	var possible_sounds: Array = item_sounds[item_type]
	var chosen = possible_sounds[randi() % possible_sounds.size()]
	if not (chosen == "sparkle" or chosen == "chime-sparkles"):
		effects_player.volume_db += 1
	effects_player.stream = load("res://assets/sounds/items/%s.mp3" % chosen)
	effects_player.play()
	anim.visible = false
	before.play("destroy")
	before.animation_finished.connect(queue_free)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is SurvivingPlayer:
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
