extends Area2D

@onready var sprite = $Sprite2D
@onready var exclamation_mark = $ExclamationMark

var interacted: bool = false
var time_alive: float = 0
var balloon_scene = preload("res://Dialogue/game_dialogue_balloon.tscn")


func _ready():
	#debug
	exclamation_mark.visible = true

	# Enable input detection for Area2D
	set_pickable(true)
	connect("input_event", _on_input_event)

func _process(delta):
	time_alive += delta
	if not interacted:
		exclamation_mark.modulate.a = 0.5 + sin(time_alive * 2) * 0.5

func _on_input_event(_viewport, event, _shape_idx):
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if not interacted:
			print("Tombstone1 received input event via Area2D!")
			#code này dành cho dấu "!"
			interacted = true
			exclamation_mark.visible = false
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			#link tới bong bóng dialogue
			balloon.start(load("res://Dialogue/tombstone.dialogue"), "start")
			await get_tree().create_timer(0.2).timeout
