extends Node2D

@export var projectile_scene: PackedScene = preload("res://Res/Minigame-1/Projectile.tscn")
@export var min_spawn_interval: float = 0.5
@export var max_spawn_interval: float = 1.0
@export var projectiles_per_burst: int = 20
@export var move_speed: float = 100
@export var wave_amplitude: float = 50
@export var wave_frequency: float = 2

@onready var timer = $Timer
@onready var sprite = $Sprite2D
var screen_width: float
var time_alive: float = 0
var moving_right: bool = true
var pattern_toggle: bool = true

func _ready():
	screen_width = get_viewport_rect().size.x
	position = Vector2(screen_width / 2, 50)
	set_random_timer()
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _process(delta):
	time_alive += delta
	position.x += move_speed * delta * (1 if moving_right else -1)
	position.y = 50 + sin(time_alive * wave_frequency) * wave_amplitude
	sprite.rotation += delta  # Visual flair
	if position.x > screen_width - 20:
		moving_right = false
	elif position.x < 20:
		moving_right = true

func _on_timer_timeout():
	if pattern_toggle:
		spawn_radial_pattern()
	else:
		spawn_aimed_pattern()
	pattern_toggle = !pattern_toggle
	set_random_timer()
func set_random_timer():
	timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)

func spawn_radial_pattern():
	var angle_step = 2 * PI / projectiles_per_burst
	for i in range(projectiles_per_burst):
		var projectile = projectile_scene.instantiate()
		var angle = i * angle_step + time_alive * 0.5
		projectile.direction = Vector2(cos(angle), sin(angle)).normalized()
		projectile.position = position
		get_parent().add_child(projectile)

func spawn_aimed_pattern():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		for i in range(3):
			var projectile = projectile_scene.instantiate()
			projectile.direction = (player.global_position - position).normalized()
			projectile.position = position
			get_parent().add_child(projectile)
