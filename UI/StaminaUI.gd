extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stamina
var max_stamina

onready var stamina_bar = $HBoxContainer/StaminaBar

# Called when the node enters the scene tree for the first time.
func _ready():
	self.stamina = PlayerStats.stamina
	self.max_stamina = PlayerStats.max_stamina
	stamina_bar.set_max(max_stamina)
	stamina_bar.set_value(max_stamina)
	PlayerStats.connect("stamina_changed", self, "set_stamina")


func set_stamina(value):
	stamina_bar.value = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
