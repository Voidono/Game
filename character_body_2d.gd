extends CharacterBody2D


@export var speed: float = 200.0
@export var gravity: float = 500.0

func _physics_process(delta):
	# Áp dụng trọng lực
	velocity.y += gravity * delta
	
	# Lấy input từ người chơi
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Di chuyển trái/phải
	if direction:
		velocity.x = direction * speed
		# Quay mặt theo hướng di chuyển
		if direction > 0:
			$An1.flip_h = false
		else:
			$An1.flip_h = true
	else:
		velocity.x = 0
	
	# Áp dụng chuyển động
	move_and_slide()
