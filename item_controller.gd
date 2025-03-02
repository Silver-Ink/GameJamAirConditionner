extends Node2D

var lst_spawn_point : Array[Marker2D]

var sc_item = preload("res://item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(get_child_count()):
		lst_spawn_point.append(get_child(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_item_wave():
	var lstId : Array[int]
	for i in range(3):
		var randId = randi_range(0, lst_spawn_point.size())
		while (lstId.find(randId) != -1):
			randId = randi_range(0, lst_spawn_point.size())
		lstId.append(randId)
		
		var item : Item = sc_item.instantiate()
		item.init()
	
		
	
	
	
