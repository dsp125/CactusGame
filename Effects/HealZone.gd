extends Area2D

var player = null
export var time_per_tick = 0.25

func _on_HealZone_area_entered(area):
	pass # Replace with function body.


func _on_HealZone_body_entered(body):
	print(body)
	player = body
	player.healing_timer.start(time_per_tick)

func _on_HealZone_body_exited(body):
	player.healing = false
	player.healing_timer.stop()
