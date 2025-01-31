extends Node

export var max_health = 1
export var max_stamina = 10
export(String) var status = ""
onready var health = max_health setget set_health

signal no_health
signal health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed",health)
	if(health <= 0):
		emit_signal("no_health")
