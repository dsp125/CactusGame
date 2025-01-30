extends Area2D

var player = null
export var radius = 100
onready var zone = $CollisionShape2D

func _ready():
	zone.shape.set_radius(radius)
	
func can_see_player():
	return player != null
	
func _on_PlayerDetectionZone_body_entered(body):
	player = body
	
func _on_PlayerDetectionZone_body_exited(body):
	player = null # Replace with function body.
