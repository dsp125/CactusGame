extends Area2D

var player = null


func _on_HealZone_area_entered(area):
	pass # Replace with function body.


func _on_HealZone_body_entered(body):
	print(body)
	player = body
	player.healing_timer.start(0.5)

func _on_HealZone_body_exited(body):
	player.healing = false
	player.healing_timer.stop()
