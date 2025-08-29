extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/soundbegin.tscn")
	pass


func _on_button_3_pressed():
	get_tree().quit()
	pass # Replace with function body.
