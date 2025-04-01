extends Node2D

@onready var exclamation_mark = $ExclamationMark
@onready var dialogue_box = $DialogueBox
@onready var sprite = $Sprite2D

var touched = false  # Biến kiểm tra xem đã chạm chưa

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		if not touched and is_touched(event.position):
			touched = true
			exclamation_mark.visible = false  # Ẩn dấu chấm than
			dialogue_box.visible = true  # Hiện hộp thoại

func is_touched(touch_pos):
	var char_rect = sprite.get_texture().get_size() * sprite.scale
	var global_rect = Rect2(global_position, char_rect.size)
	return global_rect.has_point(touch_pos)
