extends Node2D

const SPAWN_INTERVAL = .5
const MIN_NEXT_WAVE = .3
const MAX_NEXT_WAVE = 1.4

var lst_spawn_point : Array[Marker2D]
var lst_living_item : Array[Item]
var lst_living_item_pos_id : Array[int]

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
func spawn_item_wave(count : int, except := -1):
	lst_living_item_pos_id.clear()
	lst_living_item.clear()
	for i in range(count):
		var randId = randi() % lst_spawn_point.size()
		while (lst_living_item_pos_id.find(randId) != -1 || randId == except):
			randId = randi() % lst_spawn_point.size()
		lst_living_item_pos_id.append(randId)
		
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
	
	var item_count = randi_range(1, 3)
	var previous_item_id : int = lst_living_item.find(caller)
	if (previous_item_id == -1):
		printerr("L'item déclencheur n'est pas dans la liste")
	var previous_item_pos_id = lst_living_item_pos_id[previous_item_id]
	get_tree().create_timer(randf_range(MIN_NEXT_WAVE, MAX_NEXT_WAVE)). \
	timeout.connect(spawn_item_wave.bind(item_count, previous_item_pos_id))
	
	
	
	
