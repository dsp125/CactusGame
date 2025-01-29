extends Area2D

export var speed = 50
var direction = Vector2.ZERO

func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta


func destroy():
	queue_free()
	

func _on_Area2D_area_entered(area):
	print(area)
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	print(body)
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	print("leaving")
	destroy()
	pass # Replace with function body.
