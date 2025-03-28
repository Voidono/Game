extends Area2D

@export var normal_speed: float = 300.0  # Normal movement speed
@export var focus_speed: float = 150.0   # Slower speed for precision
var speed: float = normal_speed
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("player")  # For spawner tracking

func _process(delta):
	var velocity = Vector2.ZERO
	# Directional input
	if Input.is_action_pressed("Right"):
		velocity.x += 1
	if Input.is_action_pressed("Left"):
		velocity.x -= 1
	
	# Focus mode (hold Shift to slow down)
	speed = focus_speed if Input.is_action_pressed("Focus") else normal_speed
	
	# Normalize diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Move and clamp to screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
