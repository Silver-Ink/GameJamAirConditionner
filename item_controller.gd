extends Node2D

const SPAWN_INTERVAL = .5

var lst_spawn_point : Array[Marker2D]

var lst_living_item : Array[Item]

var sc_item = preload("res://item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(get_child_count()):
		lst_spawn_point.append(get_child(i))
		
	spawn_item_wave(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Please don't input more than spawn point count !?
func spawn_item_wave(count : int):
	var lstId : Array[int]
	for i in range(count):
		var randId = randi() % lst_spawn_point.size()
		while (lstId.find(randId) != -1):
			randId = randi() % lst_spawn_point.size()
		lstId.append(randId)
		
		get_tree().create_timer(SPAWN_INTERVAL * i).timeout.connect(_spawn_item.bind(randId))
	
func _spawn_item(idPos : int):
	var item : Item = sc_item.instantiate()
	item.global_position = lst_spawn_point[idPos].global_position
	add_child(item)
	item.pick_up.connect(_end_wave)
	lst_living_item.append(item)
	
	
func _end_wave(caller):
	for item in lst_living_item:
		if (item != caller):
			item.kill()
	
	
	
