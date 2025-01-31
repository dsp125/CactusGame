extends Node

export var max_health = 1
export var max_stamina = 5

export(String) var status = "" setget set_status
onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina
onready var temp_health = 0 setget set_temp_health


signal no_health
signal health_changed(value)
signal temp_health_changed(value)
signal stamina_changed(value)
signal status_changed(value)

func set_health(value):
	health = clamp(value,0,max_health)
	print(health)
	emit_signal("health_changed",health)
	if(health <= 0):
		emit_signal("no_health")

func set_temp_health(value):
	temp_health = value
	emit_signal("temp_health_changed",health)
	if(health <= 0):
		emit_signal("no_temp_health")

func set_stamina(value):
	stamina = min(value,max_stamina)
	emit_signal("stamina_changed",stamina)

func set_status(value):
	status = value
	emit_signal("status_changed",status)
