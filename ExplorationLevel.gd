extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SEED_VALUE = 3605435

#Onready
onready var proc_gen_map_base = $ProcGenDesert
onready var enemy_spawner = $YSort/EnemySpawner
onready var playable_space = proc_gen_map_base.playable_tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	
	proc_gen_map_base.run_generation(SEED_VALUE)
	
	print("width: ", proc_gen_map_base.MAP_WIDTH)
	print("height: ", proc_gen_map_base.MAP_HEIGHT)
	#print("level:  ", proc_gen_map_base.map_grid)
	print("playable: ", playable_space)
	enemy_spawner.spawn_bears(10,playable_space,SEED_VALUE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
