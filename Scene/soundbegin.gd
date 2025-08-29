extends Node2D


var next_scene_path = "res://Scene/Game1.tscn"

@onready var audio_player = $"bản tuyên ngôn"


func _ready():
	audio_player.finished.connect(_on_bản_tuyên_ngôn_finished)


func _on_bản_tuyên_ngôn_finished():
	get_tree().change_scene_to_file("res://Scene/Game1.tscn")
