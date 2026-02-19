extends Control

@onready var hunger = $HungerProgressBar

@export var player: CharacterBody3D

#This will most likely be changed this hunger goes down too fast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hunger.value = hunger.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_hunger(change_value: int):
	hunger.value += change_value
	# Needs to be linked to the gamestate script so that the bar visibly changes and gets updated
	GameState.set_value("hunger", hunger.value)
	
	#To enusre that the player's hunger doesn't go over or under the hunger value
	hunger.value = clamp(hunger.value, 0, 100)

func _on_hunger_timer_timeout() -> void:
	#Where the player loses hunger over time but will changed to something else
	change_hunger(-2)
