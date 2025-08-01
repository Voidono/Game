extends Area2D

func _ready():
	add_to_group("bad")
	# Set up collision shape and sprite
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(50, 50)
	collision.shape = shape
	add_child(collision)


func _process(delta):
	position.x -= 300 * delta # Match background speed
	if position.x < -100:
		queue_free()

func play_animation():
	# Add animation logic (e.g., scale up and fade)
	var tween = create_tween()
	tween.tween_property($An5, "scale", Vector2(1.5, 1.5), 0.3)
	tween.tween_property($An5, "modulate:a", 0.0, 0.3)
