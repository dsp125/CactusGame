extends RichTextLabel


export (int) var speed = 4
export (bool) var fade = true

var time = 0
var sin_time = 0
var _visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	time += delta
	sin_time = sin(time*speed)
	flash_my_text(delta)

func flash_my_text(_delta):
	if !fade:
		if sin_time > 0:
			_visible = true
		else:
			_visible = false
	else:
		_visible = true
		modulate.a = sin_time
	visible = _visible

