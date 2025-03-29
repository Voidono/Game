extends Area2D

var initial_speed: float = 50
var acceleration: float = 200
var velocity: Vector2 = Vector2.ZERO
var is_cluster: bool = false  # New property
const SCREEN_WIDTH: int = 800
const SCREEN_HEIGHT: int = 600

func _ready():
	add_to_group("bomb")
	if velocity == Vector2.ZERO:
		velocity.y = initial_speed

func _process(delta):
	velocity.y += acceleration * delta
	position += velocity * delta
	if position.y > SCREEN_HEIGHT - 300 and is_cluster:  # Explode near bottom
		spawn_cluster_shrapnel()
		queue_free()
	elif position.y > SCREEN_HEIGHT or abs(position.x) > SCREEN_WIDTH * 1.5:
		queue_free()

func spawn_cluster_shrapnel():
	for i in range(5):  # Spawn smaller bombs
		var shrapnel = duplicate()  # Create a copy of self
		shrapnel.position = position
		shrapnel.velocity = Vector2(cos(i * 2 * PI / 5), sin(i * 2 * PI / 5)) * 100
		shrapnel.is_cluster = false  # Prevent infinite clusters
		shrapnel.scale = Vector2(0.5, 0.5)  # Smaller size
		get_parent().add_child(shrapnel)
