extends Node2D

@onready var slime: Slime = $Slime

var sc_slime : PackedScene = preload("res://slime.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("RespawnPlayer")):
		get_viewport().set_input_as_handled()
		var transform : Transform2D = slime.get_player_transform()
		var new_slime = sc_slime.instantiate()
		new_slime.set_player_transform(transform)
		swap_slime.call_deferred(new_slime)
		
func swap_slime(new_slime: Slime):
	slime.queue_free()
	slime = new_slime
	add_child(new_slime)
		
