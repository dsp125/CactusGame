extends Area2D

var invincible = false setget set_invincible

onready var collisionShape = $CollisionShape2D
onready var timer = $Timer
signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	self.set_deferred("monitoring",false)
	self.set_deferred("monitorable",false)

func _on_Hurtbox_invincibility_ended():
	self.set_deferred("monitoring",true)
	self.set_deferred("monitorable",true)
	timer.stop()
