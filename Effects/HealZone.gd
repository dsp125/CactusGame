extends Area2D

var player = null


func _on_HealZone_area_entered(area):
	pass # Replace with function body.


func _on_HealZone_body_entered(body):
	print(body)
	body = player
