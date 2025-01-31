extends Panel

onready var sprite = $Heart
export onready var empty = false

func update_heart(whole):
	if whole == true:
		sprite.frame = 0
	else:
		sprite.frame += 1
		if(sprite.frame == 4):
			empty = true

func is_empty():
	return empty
