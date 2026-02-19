extends Node
class_name StateMachine

@export var InitialState: State

var current_state: State = null
var states: Dictionary = {}

func _ready() -> void:
	# Make sure everything is in lower case so that names doesn't matter
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	
	if InitialState:
		current_state = InitialState
		InitialState.enter()

#Always checking to see if the state needs to be checked
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

#Always checking to see if the state needs to be checked
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

#If the state needs to be changed this function is called
func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states[new_state_name.to_lower()]
	
	#Will exit the current state
	if current_state:
		current_state.exit()
	
	#Begins entering the new state
	new_state.enter()
	current_state = new_state
