extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#Audio Controllers
onready var menu_audio_theme = $MainMenuTheme
onready var menu_audio_click = $MenuClick
onready var menu_audio_hover = $MenuHover

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	play_pressed_audio()
	get_tree().change_scene("res://World.tscn")
	
func _on_Controls_pressed():
	play_pressed_audio()

func _on_Options_pressed():
	play_pressed_audio()
	
	get_tree().change_scene("res://SettingsMenu.tscn")

func _on_Quit_pressed():
	play_pressed_audio()
	get_tree().quit()
	
func _on_button_mouse_entered():
	menu_audio_hover.play()
	
func play_pressed_audio():
	menu_audio_click.play()

