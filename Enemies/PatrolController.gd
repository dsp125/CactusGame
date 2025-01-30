extends Node2D

export(int) var patrol_range = 150

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

func update_target_position():
	var target_vector = Vector2(rand_range(-patrol_range,patrol_range), rand_range(-patrol_range,patrol_range))
	target_position = start_position + target_vector
	print(target_position)

func get_time_left():
	return timer.time_left

func start_patrol_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position() # Replace with function body.
