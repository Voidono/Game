extends Node2D

var speed = 100  # Pixels per second (adjust for "slow" movement)

func _process(delta):
	# Move downward (increasing y in Godot's 2D coordinate system)
	position.y += speed * delta
	
	# Optional: Remove projectile if it goes off-screen
	if position.y > get_viewport_rect().size.y:
		queue_free()  # Delete the projectile
