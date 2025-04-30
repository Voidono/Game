extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim = get_node("Container/AnimatedSprite2D")
@onready var container = get_node("Container")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	if direction == -1 or direction == 1:
		velocity.x = direction * SPEED
		container.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	if direction == 1 or direction == -1:
		anim.play("running")
	else:
		anim.play("idle")
	
	
	move_and_slide()
