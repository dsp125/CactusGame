extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text
var sunspot = preload("res://Objectives/Sunspot.tscn")
var rand = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_sunspots(count:int,playable:Array,seed_value:int):
	rand.set_seed(seed_value)
	for i in range(0,count):
		var sun = sunspot.instance()
		sun.position = get_valid_position(playable)
		get_tree().current_scene.add_child(sun)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_valid_position(playable:Array) -> Vector2:
	var attempts = 0
	var valid_found = false
	while !valid_found and attempts < 100:
		var index = rand.randi_range(0,playable.size()-1)
		var cell = playable[index]
		var top = [cell[0], cell[1] - 16]
		var top_left = [cell[0] - 16, cell[1] - 16]
		var left = [cell[0] - 16, cell[1]]
		if playable.has(top) and playable.has(top_left) and playable.has(left):
			valid_found = true
			return Vector2(cell[0]+8,cell[1]+8)
		attempts += 1
	print("No Valid Sunspot found after: ", attempts, " attempts.")
	return Vector2(0,0)
	
