extends Node2D

@export var bomb_scene: PackedScene = preload("res://Minigame-1/Projectile.tscn")
@export var min_spawn_interval: float = 0.5
@export var max_spawn_interval: float = 1.0
@export var bombs_per_drop: int = 2
@export var base_speed: float = 150  # Base horizontal speed (pixels/sec)
@export var max_speed: float = 300   # Max speed during bursts
@export var wave_amplitude: float = 50  # Horizontal wave width

@onready var timer = $Timer
@onready var sprite = $Sprite2D
const SCREEN_WIDTH: int = 800
const SCREEN_HEIGHT: int = 600
var time_alive: float = 0
var moving_right: bool = true
var current_speed: float = base_speed
var roll_active: bool = false
var roll_timer: float = 0
var roll_direction: float = 0
var swoop_active: bool = false
var swoop_target_y: float = 0

func _ready():
	set_random_timer()
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _process(delta):
	time_alive += delta
	
	# Handle swoop (for line bombs)
	if swoop_active:
		position.y = move_toward(position.y, swoop_target_y, 100 * delta)  # Smooth swoop
		sprite.rotation = lerp(sprite.rotation, 0.3, delta * 5)  # Tilt downward
		if abs(position.y - swoop_target_y) < 5:
			swoop_active = false
	else:
		# Normal movement with curved path
		var wave_offset = sin(time_alive * 2) * wave_amplitude
		position.x += current_speed * delta * (1 if moving_right else -1) + wave_offset * delta
		position.x = clamp(position.x, 40, SCREEN_WIDTH - 40)
		position.y = move_toward(position.y, 50, 50 * delta)  # Return to base altitude
		sprite.rotation = lerp(sprite.rotation, (1 if moving_right else -1) * 0.2, delta * 5)  # Slight tilt
	
	# Speed burst
	if fmod(time_alive, randf_range(5, 10)) < 0.1:
		current_speed = max_speed
	else:
		current_speed = move_toward(current_speed, base_speed, 50 * delta)
	
	# Reverse direction at edges
	if position.x >= SCREEN_WIDTH - 40:
		moving_right = false
	elif position.x <= 40:
		moving_right = true

func _on_timer_timeout():
	var pattern = randi() % 3  # Random pattern
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
		bomb.velocity.x = randf_range(-50, 50)
		bomb.add_to_group("bomb")
		get_parent().add_child(bomb)

func spawn_line_bombs():
	sprite.modulate = Color.YELLOW  # Warning
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE
	for i in range(3):
		var bomb = bomb_scene.instantiate()
		bomb.position = position + Vector2((i - 1) * 30, 0)
		bomb.add_to_group("bomb")
		get_parent().add_child(bomb)
	if not swoop_active and not roll_active:
		swoop_active = true		
		swoop_target_y = randf_range(100, SCREEN_HEIGHT / 6)

func spawn_cluster_bombs():
	var bomb = bomb_scene.instantiate()
	bomb.position = position
	bomb.is_cluster = true
	bomb.add_to_group("bomb")
	get_parent().add_child(bomb)
	# Trigger barrel roll when dropping cluster
	if not roll_active and not swoop_active:
		roll_active = true
		roll_timer = 0.5
		roll_direction = 1 if randf() < 0.5 else -1
