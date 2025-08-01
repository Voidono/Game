extends Node2D

#Game variables
var score = 0
var target_score = 500
var is_game_over = false
var speed = 300.0
var spawn_interval = 1.5

#Preload scenes
var zone_scene = preload("res://Scene/enemy zone.tscn")

#Node references
@onready var player = $CharacterBody2D
@onready var score_label = $CanvasLayer/Label
@onready var game_over_label = $CanvasLayer2/Label
@onready var spawn_timer = $Timer
@onready var background = $ParallaxBackground

func _ready():
	# Initialize UI for mobile
	score_label.text = "Score: 0"
	game_over_label.hide()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

#Optimize for touch input
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if is_game_over:
		return

#Move background
	background.scroll_offset.x -= speed * delta

func _input(event):
	if is_game_over:
		if event is InputEventScreenTouch and event.pressed:
			get_tree().reload_current_scene()
		return

#Handle touch input
	if event is InputEventScreenTouch and event.pressed:
		var clicked_correctly = false
		for area in get_tree().get_nodes_in_group("good"):
			if area.overlaps_body(player):
				clicked_correctly = true
				area.play_animation()
				update_score(10)
				area.queue_free()
				break
			else:
				clicked_correctly = true
				update_score(0)
				break

		for area in get_tree().get_nodes_in_group("bad"):
			if area.overlaps_body(player):
				clicked_correctly = false
				area.play_animation()
				update_score(-20)
				game_over()
				get_tree().change_scene_to_file("res://Scene/bachkhoa.tscn")
				break


func _on_SpawnTimer_timeout():
	if is_game_over:
		return

#Spawn new highlight zone
	var zone = zone_scene.instantiate()
	zone.position = Vector2(800, 400) # Adjusted for typical mobile screen
	add_child(zone)
	spawn_timer.start()

func update_score(amount):
	score += amount
	score_label.text = "Score: " + str(score)

	if score >= target_score:
		win_game()
	elif score < 0:
		game_over()

func game_over():
	is_game_over = true
	game_over_label.text = "Game Over!\nTap to Restart"
	game_over_label.show()
	spawn_timer.stop()

func win_game():
	is_game_over = true
	game_over_label.text = "You Win!\nTap to Restart"
	game_over_label.show()
	spawn_timer.stop()
