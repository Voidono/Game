extends CharacterBody2D


@export var speed: float = 300.0
@export var gravity: float = 500.0
@onready var anim = get_node("container/AnimatedSprite2D")
@onready var container = get_node("container")

func _physics_process(delta):
	# Áp dụng trọng lực
	velocity.y += gravity * delta
	
	# Lấy input từ người chơi
	var direction = Input.get_axis("Left", "Right")
	
	# Di chuyển trái/phải
	if direction:
		velocity.x = direction * speed
		# Quay mặt theo hướng di chuyển
	if direction == 1 or direction == -1:
		velocity.x = direction * speed
		container.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
		
	# Anim nhân vật
	if direction == 1 or direction == -1:
		anim.play("running")
	else:
		anim.play("stand")
	
	
	# Áp dụng chuyển động
	move_and_slide()
