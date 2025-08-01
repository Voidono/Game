extends Node2D


@onready var body_sprite = $Body/body

var body_keys = []
var current_body_index = 0

func _ready():
	set_sprite_keys()
	update_sprite()

func set_sprite_keys():
	body_keys = Global.bodies_collection.keys()

func update_sprite():
	var current_sprite = body_keys[current_body_index]
	body_sprite.texture = Global.bodies_collection[current_sprite]
	
	
	Global.selected_body = current_sprite 



func _on_button_pressed():
	current_body_index = (current_body_index + 1) % body_keys.size()
	update_sprite()
