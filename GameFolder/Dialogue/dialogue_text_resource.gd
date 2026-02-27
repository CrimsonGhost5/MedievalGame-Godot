extends DE
class_name DialogueText

#The name of the character who is talking
@export var speaker_name: String

#The dialogue being spoken 
@export_multiline var text: String
#How fast each character of text is displayed
@export_range(0.1, 30.0, 0.1) var text_speed: float = 1.0

#Audio that plays per character of text
@export var text_sound: AudioStream
#Volume of the sound
@export var text_volume_db: int
#The minimum and maximum the sound of each character
@export var text_volume_pitch_min: float = 0.85
@export var text_volume_pitch_max: float = 1.15

#The position that the character moved to
@export var camera_position: Vector3 = Vector3(999.999, 999.999, 999.999)
#How long the character will take to get the position
@export_range(0.05, 10.0, 0.05) var camera_transition_time: float = 1.0
