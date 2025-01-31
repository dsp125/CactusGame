extends Control


export var total_health : int = 18
export var max_health : int = 18 #regular + temp
var max_temp_health : int = 24
var max_red_hearts : int = 6
var hearts : int = 6  # This will represent the current number of hearts
var health_per_heart = 3
#var max_hearts : int = 6  # Max number of hearts when the health is at full value
# Array to hold references to the hearts' TextureProgress bars
var heart_bars : Array = []

onready var heart_container = $HeartContainer

func _ready():
	# Initially update the health display with the correct number of hearts
	self.max_health = PlayerStats.max_health
	self.max_temp_health = PlayerStats.max_temp_health
	self.total_health = PlayerStats.health
	PlayerStats.connect("health_changed", self, "modify_health")
	update_health_display()


# Function to update the health display
func update_health_display():
	# First, remove any existing heart bars
	for h in heart_bars:
		h.queue_free()
	heart_bars = []
		

	# Recalculate the number of hearts based on the current health
	hearts = int(round(total_health / health_per_heart))  # Calculate how many hearts to display
	if total_health % health_per_heart != 0:
		hearts += 1

	# Create and add new heart bars based on the current health
	for i in range(hearts):
		var heart = TextureProgress.new()
		heart.fill_mode = 3
		heart.min_value = 0
		heart.max_value = health_per_heart  # Each heart represents a portion of max health
		heart.value = health_per_heart  # Set the full value initially (full heart)
		heart.texture_under = preload("res://Sprites/UI/empty_heart.png")  # Empty heart texture
		if(i >= max_red_hearts):
			heart.texture_progress = preload("res://Sprites/UI/blue_heart_fill.png")  # Filled heart texture
		else:
			heart.texture_progress = preload("res://Sprites/UI/red_heart_fill.png")  # Filled heart texture
		# Add the heart bar to the container
		heart_container.add_child(heart)
		heart_bars.append(heart)
		

	# After creating the hearts, update each heart's value based on the total health
	var remaining_health = total_health
	for i in range(hearts):
		if remaining_health >= health_per_heart:
			heart_bars[i].value = health_per_heart
			remaining_health -= health_per_heart
		else:
			heart_bars[i].value = remaining_health
			remaining_health = 0  # No more health left to distribute

# Function to modify the health and refresh the display
func modify_health(amount : int):
	total_health = amount
	print("modify health:", amount)
	update_health_display()
