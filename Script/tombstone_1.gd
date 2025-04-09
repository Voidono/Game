extends Area2D

@onready var sprite = $Sprite2D
@onready var exclamation_mark = $ExclamationMark
@onready var dialogue_box = $DialogueBox
@onready var dialogue_label = $DialogueBox/RichTextLabel

var interacted: bool = false
var time_alive: float = 0

func _ready():
	if not sprite:
		print("Error: Sprite2D node not found in Tombstone1!")
	if not exclamation_mark:
		print("Error: ExclamationMark node not found in Tombstone1!")
	if not dialogue_box:
		print("Error: DialogueBox node not found in Tombstone1!")
	if not dialogue_label:
		print("Error: RichTextLabel node not found in DialogueBox!")
	
	exclamation_mark.visible = true
	dialogue_box.visible = false

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
			interacted = true
			exclamation_mark.visible = false
			dialogue_box.visible = true
			print("DialogueBox visibility set to: ", dialogue_box.visible)
			await get_tree().create_timer(0.2).timeout
