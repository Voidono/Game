extends Node2D

# Preload the projectile scene
@export var projectile_scene: PackedScene = preload("res://Scene/Projectile.tscn")
@export var min_spawn_interval: float = 0.1  # Minimum time between spawns
@export var max_spawn_interval: float = 0.1  # Maximum time between spawns
@export var projectiles_per_burst: int = 10  # Number of projectiles per burst
@export var move_speed: float = 1000  # Horizontal movement speed (pixels/sec)
@export var wave_amplitude: float = 50  # Vertical wave height
@export var wave_frequency: float = 2  # How fast the wave oscillates

@onready var timer = $Timer  # Reference to the Timer node
@onready var sprite = $Sprite2D  # Reference to the Sprite2D node
var screen_width: float
var time_alive: float = 0  # Tracks time for wave movement

func _ready():
	# Get the screen width
	screen_width = get_viewport_rect().size.x
	
	# Start at the left side of the screen, slightly below the top
	position = Vector2(0, 50)
	
	# Set up the timer
	set_random_timer()
	timer.one_shot = false  # Timer repeats
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _process(delta):
	# Update time for wave movement
	time_alive += delta
	
	# Move horizontally across the screen
	position.x += move_speed * delta
	
	# Add vertical wave motion
	position.y = 50 + sin(time_alive * wave_frequency) * wave_amplitude
	
	# Reverse direction when hitting screen edges
	if position.x > screen_width:
		position.x = screen_width
		move_speed = -move_speed  # Move left
	elif position.x < 0:
		position.x = 0
		move_speed = -move_speed  # Move right

func _on_timer_timeout():
	# Spawn a burst of projectiles from the spawner's current position
	for i in range(projectiles_per_burst):
		spawn_projectile()
	
	# Reset timer with a new random interval
	set_random_timer()

func set_random_timer():
	timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)

func spawn_projectile():
	# Instance a new projectile
	var projectile = projectile_scene.instantiate()
	
	# Spawn at the spawner's current position
	projectile.position = position  # Use spawner's position
	
	# Add slight random angle to the projectile's direction
	projectile.direction = Vector2(
		randf_range(-0.2, 0.2),  # Slight x variation
		1.0  # Mostly downward
	).normalized()
	
	# Add to the scene
	get_parent().add_child(projectile)
