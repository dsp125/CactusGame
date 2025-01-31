extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SEED_VALUE = 69420
export var bear_count = 4
export var sunspot_count = 10

#Onready
onready var proc_gen_map_base = $ProcGenDesert
onready var enemy_spawner = $YSort/EnemySpawner
onready var sunspot_spawner = $YSort/SunspotSpawner
onready var playable_space = proc_gen_map_base.playable_tiles

var bears : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	proc_gen_map_base.run_generation(SEED_VALUE)
	
	#print("width: ", proc_gen_map_base.MAP_WIDTH)
	#print("height: ", proc_gen_map_base.MAP_HEIGHT)
	#print("level:  ", proc_gen_map_base.map_grid)
	#print("playable: ", playable_space)
	var bears = enemy_spawner.spawn_bears(bear_count,playable_space,SEED_VALUE)
	var sunspots = sunspot_spawner.spawn_sunspots(sunspot_count,playable_space,SEED_VALUE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ExplorationLevel_child_exiting_tree(node):
	pass # Replace with function body.
