extends DE
class_name DialogueFunction

#Is the node that has the function that will be called
@export var target_path: NodePath
#Is the name of the function that will be called
@export var function_name: String
#Well call any built in variables in the function
@export var function_argument: Array

#Hide dialogue during the fucntion call
@export var hide_dialogue_box: bool
#Contain the name of thhe signal that thhe game is waiting for to continue dialogue
@export var wait_for_signal_to_continue: String = ""
