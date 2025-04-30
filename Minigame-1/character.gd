extends Area2D

@export var normal_speed: float = 300.0  # Normal movement speed
@export var focus_speed: float = 150.0   # Slower speed for precision
@onready var anim = get_node("container/AnimatedSprite2D")
@onready var container = get_node("container")

var speed: float = normal_speed
const SCREEN_WIDTH: int = 800
const SCREEN_HEIGHT: int = 600
var screen_size: Vector2 = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)

func _ready():
	position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 130)  # Start near bottom
	add_to_group("player")  # For spawner tracking (if you add aimed bombs later)

func _process(delta):
	var velocity = Vector2.ZERO
	# Directional input
	if Input.is_action_pressed("Right"):
		velocity.x += 1
	if Input.is_action_pressed("Left"):
		velocity.x -= 1
	
	
	if velocity.x == 1 or velocity.x == -1:
		anim.play("swim")
	
	# Focus mode (hold Shift for precision)
	speed = focus_speed if Input.is_action_pressed("Focus") else normal_speed
	
	# Normalize diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Move and clamp to screen (stay near bottom for swimmer theme)
	position += velocity * delta
	



func _on_area_entered(area):
	if area.is_in_group("bomb"):  # Assuming bombs are in "bomb" group
		print("Hit by bomb! Game Over!")  # Replace with game over logic
		get_tree().change_scene_to_file("res://Scene/thach_han.tscn")
		# Optional: queue_free() to remove swimmer or trigger reset
