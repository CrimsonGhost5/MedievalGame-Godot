extends Node
class_name State
signal Transitioned(state: State, new_state_name: String)

var object

func enter():
	pass

func exit():
	pass

func process(_delta: float):
	pass

func physics_process(_delta: float):
	pass
