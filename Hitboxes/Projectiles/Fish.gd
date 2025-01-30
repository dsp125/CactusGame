extends Node2D


export var speed: float = 100
export var distance: float = 100
var duration:float = distance/speed
var direction = Vector2.ZERO

onready var hitbox = $Hitbox

func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	hitbox.knockback_vector = direction
	global_position += direction * speed * delta


func destroy():
	queue_free()

func _on_Hitbox_area_entered(area):
	print("Target Hit:", area.get_parent())
	destroy()

func _on_Hitbox_body_entered(_body):
	destroy() # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	print("Leaving Screen")
	destroy()
