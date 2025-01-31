extends Control


var hearts = 6 setget set_hearts
var stamina = 5 setget set_stamina
var max_hearts = 6 setget set_max_hearts
var max_stamina = 5 setget set_max_stamina

onready var splabel = $StaminaLabel
onready var heartContainer = $HeartContainer

export onready var REF_HEART = preload("res://UI/Heart.tscn")

func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	var panels = heartContainer.get_children()
	if(panels.size() > 0):
		var currentHeart = ceil(hearts/4.0) - 1
		print("Current Heart: ", currentHeart)
		panels[currentHeart].update_heart(false)

func set_stamina(value):
	stamina = clamp(value,0,max_stamina)
	if splabel != null:
		splabel.text = "SP = " + str(int(stamina))
	
func set_max_hearts(value):
	max_hearts = max(value,1)

func set_max_stamina(value):
	max_stamina = max(value,1)
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	self.max_stamina = PlayerStats.max_stamina
	self.stamina = PlayerStats.stamina
	var heart
	for i in range(PlayerStats.max_health/4):
		heart = REF_HEART.instance()
		heartContainer.add_child(heart)
#	var damage = PlayerStats.max_health % 4
#	if damage != 0:
#		heart = REF_HEART.instance()
#		for i in range(damage):
#			heart.update_heart(false)
#		heartContainer.add_child(heart)
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("stamina_changed", self, "set_stamina")
