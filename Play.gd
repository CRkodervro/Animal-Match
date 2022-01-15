extends Button

onready var GAnim = $"../../AnimationPlayer"

func _ready():
	GM.playButton = self

func _pressed():
	if GM.newGame:
		GM.newGame = false
		GM.create()
		GAnim.play("camera-zoom-out")
		yield(get_tree().create_timer(1), "timeout")
		GAnim.play("hide-play-button")
		yield(get_tree().create_timer(0.5), "timeout")
		text = "AGAIN?"
	else:
		GM.reset()
		GAnim.play("hide-play-button")
