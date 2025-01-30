extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text
var bear_banditos = preload("res://Enemies/BearBandito.tscn")
var rand = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_bears(count:int,playable:Array,seed_value:int):
	rand.set_seed(seed_value)
	for i in range(0,count):
		var bear = bear_banditos.instance()
		bear.position = get_valid_position(playable)
		get_tree().current_scene.add_child(bear)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_valid_position(playable:Array) -> Vector2:
	var index = rand.randi_range(0,playable.size()-1)
	var cell = playable[index]
	return Vector2(cell[0]+1,cell[1]+1)
	
