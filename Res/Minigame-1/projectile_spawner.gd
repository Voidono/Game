extends Node2D

@export var bomb_scene: PackedScene = preload("res://Res/Minigame-1/Projectile.tscn")
@export var min_spawn_interval: float = 0.5
@export var max_spawn_interval: float = 1.0
@export var bombs_per_drop: int = 2
@export var move_speed: float = 150
@export var altitude_variation: float = 30

@onready var timer = $Timer
@onready var sprite = $Sprite2D
const SCREEN_WIDTH: int = 800
const SCREEN_HEIGHT: int = 600
var time_alive: float = 0
var moving_right: bool = true

func _ready():
	position = Vector2(SCREEN_WIDTH / 4, 50)
	set_random_timer()
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _process(delta):
	time_alive += delta
	position.x += move_speed * delta * (1 if moving_right else -1)
	position.y = clamp(50 + sin(time_alive * 2) * altitude_variation, 0, SCREEN_HEIGHT / 4)
	if position.x > SCREEN_WIDTH - 40:
		moving_right = false
	elif position.x < 40:
		moving_right = true

func _on_timer_timeout():
	var pattern = randi() % 3  # Randomly choose a pattern
	match pattern:
		0: spawn_scatter_bombs()
		1: spawn_line_bombs()
		2: spawn_cluster_bombs()
	set_random_timer()

func set_random_timer():
	timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)

func spawn_scatter_bombs():
	for i in range(bombs_per_drop):
		var bomb = bomb_scene.instantiate()
		bomb.position = position + Vector2(randf_range(-50, 50), randf_range(-20, 20))
		bomb.velocity.x = randf_range(-50, 50)  # Slight horizontal drift
		get_parent().add_child(bomb)

func spawn_line_bombs():
	for i in range(3):  # Drop in a horizontal line
		var bomb = bomb_scene.instantiate()
		bomb.position = position + Vector2((i - 1) * 30, 0)  # Spread out
		get_parent().add_child(bomb)

func spawn_cluster_bombs():
	var bomb = bomb_scene.instantiate()
	bomb.position = position
	bomb.is_cluster = true  # Special property for cluster explosion
	get_parent().add_child(bomb)
