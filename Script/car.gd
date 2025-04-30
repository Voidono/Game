extends Area2D

var entered = false

func _on_body_entered(_body:Node2D):
	entered = true

func _process(_delta):
	if entered == true:
		get_tree().change_scene_to_file("res://Scene/thach_han.tscn")

pass
