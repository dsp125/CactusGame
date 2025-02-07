extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 25
export var FRICTION = 200
export var KNOCKBACK_SCALER = 100


enum {
	IDLE,
	PATROL,
	CHASE,
	DAMAGE,
	INSPECT,
	RETURN
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
var inspect_duration: float = 5.0
var inspect_timer: float = 0.0
var inspect_target = Vector2.ZERO

onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var patrol_controller = $PatrolController
onready var origin = global_position
onready var throwSpawn = $ThrowSpawn
onready var hurtbox = $Hurtbox

export var REF_FISH = preload("res://Hitboxes/Projectiles/Fish.tscn")

func _ready():
	animationTree.active = true

#Audio Controllers
onready var patrol_audio = $FootstepPatrol
onready var throw_fish_audio = $ThrowFish

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200 * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			stop_patrol_footsteps()
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if patrol_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,PATROL,PATROL])
				patrol_controller.start_patrol_timer(rand_range(1,3))
		PATROL:
			play_patrol_footsteps()
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
			#print("CHASING")
			play_patrol_footsteps()
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				if global_position.distance_to(player.global_position) >= 80:
					animationTree.set("parameters/Patrol/blend_position", direction)
					animationState.travel("Patrol")
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				else:
					velocity = Vector2.ZERO
					animationTree.set("parameters/Attack/blend_position", direction)
					animationState.travel("Attack")
			if player == null:
				velocity = Vector2.ZERO
				state = IDLE
		DAMAGE:
			damage_state()
			
		INSPECT:
			#print("INSPECTING")
			play_patrol_footsteps()
			seek_player()
			if inspect_timer <= inspect_duration:
				inspect_timer += delta
				inspect_for_player(delta)
				animationTree.set("parameters/Patrol/blend_position", inspect_target)
				animationState.travel("Patrol")
			else:
				inspect_timer = 0.0
				state = RETURN
		RETURN:
			#print("RETURNING")
			play_patrol_footsteps()
			seek_player()
			if global_position.distance_to(origin) < 0.25:
				animationState.travel("Idle")
				state = IDLE ## set to patrol when implemented
			else:
				animationTree.set("parameters/Patrol/blend_position", origin)
				animationState.travel("Patrol")
				return_to_origin(delta)
			

	velocity = move_and_slide(velocity)

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area:Area2D):
	stats.health -= 1
	knockback = area.knockback_vector * KNOCKBACK_SCALER
	inspect_target = Vector2(-area.knockback_vector.x,-area.knockback_vector.y)
	state = DAMAGE

func inspect_for_player(delta):
	velocity = velocity.move_toward(inspect_target * MAX_SPEED, ACCELERATION * delta)
	seek_player()
	
func return_to_origin(delta):
	velocity = velocity.move_toward((origin-global_position).normalized() * MAX_SPEED, ACCELERATION * delta)
	seek_player()

func _on_Stats_no_health():
	hurtbox.start_invincibility(1.2)
	animationState.travel("Death")

func play_patrol_footsteps():
	if not patrol_audio.playing:
		patrol_audio.play()
	
func stop_patrol_footsteps():
	if patrol_audio.playing:
		patrol_audio.stop()

func play_throw_fish_audio():
	throw_fish_audio.play()

func throw_object():
	play_throw_fish_audio()
	if REF_FISH:
		var fish = REF_FISH.instance()
		var player = player_detection_zone.player
		get_tree().current_scene.add_child(fish)
		fish.global_position = throwSpawn.global_position
		var approx_player = Vector2(player.global_position.x + rand_range(-10,10), player.global_position.y-11 + rand_range(-10,10))
		fish.rotation = fish.global_position.direction_to(approx_player).angle()

func damage_state():
	velocity = Vector2.ZERO
	if(stats.health > 0):
		animationTree.set("parameters/Damaged/blend_position", inspect_target)
		animationState.travel("Damaged")
	else:
		animationState.travel("Death")
	
func end_damage_state():
	state = INSPECT
