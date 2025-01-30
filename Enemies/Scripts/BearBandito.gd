extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 20
export var FRICTION = 200

enum {
	IDLE,
	PATROL,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var patrol_controller = $PatrolController


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200 * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if patrol_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,PATROL,PATROL])
				patrol_controller.start_patrol_timer(rand_range(1,3))
		PATROL:
			seek_player()
			if patrol_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,PATROL,PATROL])
				patrol_controller.start_patrol_timer(rand_range(1,3))
			
			var direction = global_position.direction_to(patrol_controller.target_position)
			animationTree.set("parameters/Patrol/blend_position", direction)
			animationState.travel("Patrol")
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			if global_position.distance_to(patrol_controller.target_position) <= MAX_SPEED * delta:
				state = pick_random_state([IDLE,PATROL,PATROL])
				patrol_controller.start_patrol_timer(rand_range(1,3))

		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				animationTree.set("parameters/Patrol/blend_position", direction)
				animationState.travel("Patrol")
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			if player == null:
				velocity = Vector2.ZERO
				state = IDLE
		
	velocity = move_and_slide(velocity)

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area:Area2D):
	stats.health -= 1
	knockback = area.knockback_vector * 100

func _on_Stats_no_health():
	queue_free() # Replace with function body.
