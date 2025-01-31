extends Node2D


export var speed: float = 80
export var distance: float = 100
var duration:float = distance/speed
var direction = Vector2.ZERO

onready var hitbox = $Hitbox
onready var timer = $Timer
 
 
func _ready():
	timer.start(duration)

func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	hitbox.knockback_vector = direction
	global_position += direction * speed * delta


func destroy():
	queue_free()

func _on_Hitbox_area_entered(area):
	destroy()

func _on_Hitbox_body_entered(_body):
	destroy() # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	destroy()
	
func _on_Timer_timeout():
	destroy()
