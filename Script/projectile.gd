extends Node2D

var speed = 100  # Base speed (pixels per second, adjustable for "slow")
var direction = Vector2.DOWN  # Default direction (set by spawner)

func _process(delta):
	# Move in the assigned direction
	position += direction * speed * delta
	
	# Remove if off-screen
	if position.y > get_viewport_rect().size.y or abs(position.x) > get_viewport_rect().size.x * 1.5:
		queue_free()
