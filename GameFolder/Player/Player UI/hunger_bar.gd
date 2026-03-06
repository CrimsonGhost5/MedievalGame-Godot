extends Control

@onready var hunger = $HungerProgressBar

@export var player: CharacterBody3D



var starting_hunger_timer_end: bool = false
#This will most likely be changed this hunger goes down too fast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hunger.value = hunger.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	PlayerManager.starting_hunger_timer -= 1 * delta
	if PlayerManager.starting_hunger_timer <= 0:
		PlayerManager.starting_hunger_timer == 0.0
		starting_hunger_timer_end = true
	


func change_hunger(change_value: int):
	hunger.value += change_value
	# Needs to be linked to the gamestate script so that the bar visibly changes and gets updated
	GameState.set_value("hunger", hunger.value)
	
	#To enusre that the player's hunger doesn't go over or under the hunger value
	hunger.value = clamp(hunger.value, 0, 100)

func _on_hunger_timer_timeout() -> void:
	if starting_hunger_timer_end == true:
		change_hunger(-2)
