extends Node2D

@onready var sprite = $Sprite2D
@onready var exclamation_mark = $ExclamationMark
@onready var dialogue_box = $DialogueBox
@onready var dialogue_label = $DialogueBox/RichTextLabel

var interacted: bool = false

func _ready():
	exclamation_mark.visible = true
	dialogue_box.visible = false

func _input(event):
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if not interacted and is_touched(event.position):
			interacted = true
			exclamation_mark.visible = false
			dialogue_box.visible = true

func is_touched(touch_pos: Vector2) -> bool:
	if not sprite:
		print("Error: Sprite2D node not found!")
		return false
	var char_rect = sprite.get_rect()
	var scaled_size = char_rect.size * sprite.scale
	var global_rect = Rect2(sprite.global_position - scaled_size / 2, scaled_size)
	return global_rect.has_point(touch_pos)
