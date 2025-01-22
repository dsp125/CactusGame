extends KinematicBody2D

const ACCEL = 400
const MAX_SPD = 80
const FRICTION = 400

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationPlayer.play("Hop")
		velocity = velocity.move_toward(input_vector * MAX_SPD, ACCEL * delta)
		
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
		
	velocity = move_and_slide(velocity)
