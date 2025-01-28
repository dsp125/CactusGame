extends KinematicBody2D

const ACCEL = 400
const MAX_SPD = 60
const ROLL_SPEED = 75
const FRICTION = 500

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum PlayerStates{
	MOVE,
	ROLL,
	ATTACK
}

var state = PlayerStates.MOVE

func _process(delta):
	match state:
		PlayerStates.MOVE:
			move_state(delta)
		
		PlayerStates.ROLL:
			roll_state(delta)
		
		PlayerStates.ATTACK:
			pass
		
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPD, ACCEL * FRICTION * delta)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	move()
	
	if Input.is_action_just_pressed("ui_roll"):
		animationTree.set("parameters/Roll/blend_position", roll_vector)
		state = PlayerStates.ROLL
		

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func roll_animation_finished():
	state = PlayerStates.MOVE

func move():
	velocity = move_and_slide(velocity)
