extends Interactable

@export var itemID := "someItem"
@export var item_amount = 0

var playback : AnimationNodeStateMachinePlayback
var open := false

func _ready() -> void:
	playback = $AnimationTree.get("parameters/playback")

func _on_interacted(body: Variant) -> void:
	if not open and GameState.get_value("key") > 0:
		open = true
		$ChestOpeningSFX.play()
		GameState.set_value("key", GameState.get_value("key") - 1)
		playback.travel("ChestOpen")
		GameState.set_value(itemID, true)
		enabled = false
