extends Node2D

var initial_speed: float = 50  # Starting slow fall (pixels/sec)
var acceleration: float = 200  # Gravity-like increase (pixels/sec^2)
var velocity: Vector2 = Vector2.ZERO
const SCREEN_WIDTH: int = 800
const SCREEN_HEIGHT: int = 600

func _process(delta):
	# Apply gravity-like acceleration
	velocity.y += acceleration * delta
	position += velocity * delta
	
	# Set initial downward movement if not already moving
	if velocity == Vector2.ZERO:
		velocity.y = initial_speed
	
	# Remove if off-screen
	if position.y > SCREEN_HEIGHT or abs(position.x) > SCREEN_WIDTH * 1.5:
		queue_free()
