extends Control

var ball_points: int = 0
var pen_points: int = 0
var wall_counter: int = 0

var t0 := Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_times()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_times()
	$ColorRect/VBoxContainer/HBoxContainer/Left/BallPoints/Label.text = str(ball_points)
	$ColorRect/VBoxContainer/HBoxContainer/Right/PenPoints/Label.text = str(pen_points)
	$ColorRect/VBoxContainer/HBoxContainer/Right/WallCounter/Label.text = "%s/5" % str(wall_counter)


func _update_times():
	var time = _time()
	$ColorRect/VBoxContainer/HBoxContainer/Left/Time/Label.text = time
	$ColorRect/VBoxContainer/HBoxContainer/Right/Time/Label.text = time


func _time() -> String:
	var now = Time.get_ticks_msec()
	var delta = now - t0
	delta = int(floor(delta / 1000))
	return "%02d:%02d" % [int(floor(delta / 60)), delta % 60]
	
func incr_surviving_player_count(item: Item):
	print("t")
	ball_points += 1
