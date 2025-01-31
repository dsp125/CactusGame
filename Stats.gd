extends Node

export var max_health = 18
export var max_stamina = 5
export var max_temp_health = 24

export(String) var status = "" setget set_status
onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina


signal no_health
signal health_changed(value)
signal temp_health_changed(value)
signal stamina_changed(value)
signal status_changed(value)

func set_health(value):
	
	health = clamp(value,0, max_temp_health)

	emit_signal("health_changed",health)
	if (health == 0):
		emit_signal("no_health")

func set_stamina(value):
	stamina = min(value,max_stamina)
	emit_signal("stamina_changed",stamina)

func set_status(value):
	status = value
	emit_signal("status_changed",status)
