extends Control
var SC_game = preload("res://Game.tscn")
var SC_credits = preload("res://CREDITS/GodotCredits.tscn")

func _on_exit_button_up() -> void:
	get_tree().quit()


func _on_tutorial_button_up() -> void:
	$ColorRect/Popup.show()


func _on_popup_ok_button_up() -> void:
	$ColorRect/Popup.hide()


func _on_start_button_up() -> void:
	var new_level = SC_game.instantiate()
	get_tree().root.add_child.call_deferred(new_level)
	queue_free.call_deferred()


func _on_credits_button_up() -> void:
	var new_level = SC_credits.instantiate()
	get_tree().root.add_child.call_deferred(new_level)
	queue_free.call_deferred()
