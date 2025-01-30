extends KinematicBody2D

const ACCEL = 400
const MAX_SPD = 60
const ROLL_SPEED = 75
const ATTACK_SPEED = 45
const FRICTION = 500

var velocity = Vector2.ZERO
var prev_vector = Vector2.DOWN #USED TO SAVE LAST FACING DIRECTION
var direction_vector = Vector2.DOWN

#Scenes instantiated via player script
export var REF_THORN = preload("res://Hitboxes/Projectiles/Thorn.tscn")

#Animation Controllers
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var thornSpawn = $ThornSpawn

#Audio Controllers
onready var thornAudio = $ThornShoot

enum PlayerStates{
	MOVE,
	ROLL,
	SHOOT
}

var state = PlayerStates.MOVE

func _process(delta):
	match state:
		PlayerStates.MOVE:
			move_state(delta)
		
		PlayerStates.ROLL:
			roll_state(delta)
		
		PlayerStates.SHOOT:
			shoot_state(delta)
		
func move_state(delta):
	var input_vector = Vector2.ZERO
	direction_vector = get_global_mouse_position() - position
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		prev_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", direction_vector)
		animationTree.set("parameters/Walk/blend_position", direction_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPD, ACCEL * FRICTION * delta)
		
	else:
		animationTree.set("parameters/Idle/blend_position", direction_vector)
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	move()
	
	if Input.is_action_just_pressed("ui_roll"):
		animationTree.set("parameters/Roll/blend_position", input_vector)
		state = PlayerStates.ROLL
	
	if Input.is_action_pressed("ui_attack"):
		if input_vector != Vector2.ZERO:
			animationTree.set("parameters/AttackWalk/blend_position", input_vector)
		else:
			animationTree.set("parameters/AttackIdle/blend_position", direction_vector)
		state = PlayerStates.SHOOT
		
# ROLLING
func roll_state(_delta):
	velocity = prev_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func roll_animation_finished():
	state = PlayerStates.MOVE


# SHOOTING THORNS
func shoot_thorn():
	thornAudio.play()
	if REF_THORN:
		var thorn = REF_THORN.instance()
		get_tree().current_scene.add_child(thorn)
		thorn.global_position = thornSpawn.global_position
		thorn.rotation = (get_global_mouse_position() - thorn.global_position).angle()
		
		#var thorn_rotation
	
func shoot_state(_delta):
	direction_vector = get_global_mouse_position() - position
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		prev_vector = input_vector
		animationTree.set("parameters/AttackIdle/blend_position", direction_vector)
		animationTree.set("parameters/AttackWalk/blend_position", direction_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", direction_vector)
		animationTree.set("parameters/Walk/blend_position", direction_vector)
		animationState.travel("AttackWalk")
		velocity = velocity.move_toward(input_vector * ATTACK_SPEED, ACCEL * FRICTION * _delta)
		
	else:
		animationTree.set("parameters/AttackIdle/blend_position", direction_vector)
		animationState.travel("AttackIdle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*_delta)
	
	move()
	
	if Input.is_action_just_pressed("ui_roll"):
		animationTree.set("parameters/Roll/blend_position", input_vector)
		state = PlayerStates.ROLL
	
	if Input.is_action_just_released("ui_attack"):
		state = PlayerStates.MOVE
	
# UPDATE PLAYER POSITION
func move():
	velocity = move_and_slide(velocity)
