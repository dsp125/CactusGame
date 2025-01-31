extends Panel

onready var sprite = $Heart
var frame = 0 setget set_frame

func set_frame(value):
	frame = clamp(value, 0, 4)
	sprite.frame = frame
