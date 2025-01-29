extends Area2D

export var speed = 80
var direction = Vector2.ZERO

func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta


func destroy():
	queue_free()
	

func _on_Area2D_area_entered(area):
	print(area)



func _on_Area2D_body_entered(body):
	print(body)
	destroy()



func _on_VisibilityNotifier2D_screen_exited():
	print("leaving")
	destroy()
