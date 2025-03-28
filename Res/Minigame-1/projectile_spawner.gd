extends Node2D

@export var bomb_scene: PackedScene = preload("res://Res/Minigame-1/Projectile.tscn")  
@export var min_spawn_interval: float = 0.5  # Time between bomb drops
@export var max_spawn_interval: float = 1.0
@export var bombs_per_drop: int = 2  # Fewer projectiles for a bomb theme
@export var move_speed: float = 150  # Plane speed (pixels/sec)
@export var altitude_variation: float = 30  # Slight up/down movement

@onready var timer = $Timer
@onready var sprite = $Sprite2D  # Plane sprite
const SCREEN_WIDTH: int = 800
const SCREEN_HEIGHT: int = 600
var time_alive: float = 0
var moving_right: bool = true

func _ready():
	position = Vector2(SCREEN_WIDTH / 4, 50)  # Start near left side
	set_random_timer()
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _process(delta):
	time_alive += delta
	# Move horizontally
	position.x += move_speed * delta * (1 if moving_right else -1)
	# Slight altitude variation (turbulence)
	position.y = clamp(50 + sin(time_alive * 2) * altitude_variation, 0, SCREEN_HEIGHT / 4)
	
	# Reverse direction at screen edges
	if position.x > SCREEN_WIDTH - 40:  # Adjust for plane sprite width
		moving_right = false
	elif position.x < 40:
		moving_right = true

func _on_timer_timeout():
	spawn_bombs()
	set_random_timer()

func set_random_timer():
	timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)

func spawn_bombs():
	for i in range(bombs_per_drop):
		var bomb = bomb_scene.instantiate()
		# Spawn bombs slightly offset from plane center (e.g., bomb bays)
		bomb.position = position + Vector2(randf_range(-20, 20), 0)
		# Bombs fall straight down (adjusted in bomb script)
		get_parent().add_child(bomb)
