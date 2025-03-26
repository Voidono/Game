extends CharacterBody2D

const Speed = 300.0
var moveDir = Vector2(0,0)

func _physics_process(delta):
	movement(delta)
	
func movement(d):
	if Input.is_action_pressed("Right"):
		moveDir.x = 1
	if Input.is_action_pressed("Left"):
		moveDir.x = -1
	
	move_and_collide(moveDir.normalized() * Speed * d)
