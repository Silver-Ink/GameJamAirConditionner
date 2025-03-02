extends Control


func _on_exit_button_up() -> void:
	get_tree().quit()


func _on_tutorial_button_up() -> void:
	$ColorRect/Popup.show()


func _on_popup_ok_button_up() -> void:
	$ColorRect/Popup.hide()


func _on_credits_button_up() -> void:
	pass # TODO: navigate to credits screen


func _on_start_button_up() -> void:
	pass # TODO: navigate to main screen
