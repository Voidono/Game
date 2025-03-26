extends Node2D

# Preload the projectile scene
@export var projectile_scene: PackedScene = preload("res://Scene/Projectile.tscn")
@export var spawn_interval_min: float = 1.0  # Minimum spawn delay (seconds)
@export var spawn_interval_max: float = 3.0  # Maximum spawn delay (seconds)

@onready var timer = $Timer  # Reference to the Timer node
var screen_width: float

func _ready():
	# Get the screen width
	screen_width = get_viewport_rect().size.x
	
	# Set up the timer
	timer.wait_time = randf_range(spawn_interval_min, spawn_interval_max)
	timer.one_shot = false  # Timer repeats
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	# Spawn a projectile
	spawn_projectile()
	
	# Reset timer with a new random interval
	timer.wait_time = randf_range(spawn_interval_min, spawn_interval_max)

func spawn_projectile():
	# Instance a new projectile
	var projectile = projectile_scene.instantiate()
	
	# Set random x-position along the top of the screen
	var random_x = randf_range(0, screen_width)
	projectile.position = Vector2(random_x, 0)  # Spawn at top (y = 0)
	
	# Add the projectile to the scene
	get_parent().add_child(projectile)  # Add to parent (e.g., main scene)
