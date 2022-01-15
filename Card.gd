extends Area2D

enum ANIMALS {
	Elephant,
	Giraffe,
	Monkey,
	Panda,
	Parrot,
	Penguin,
	Pig,
	Rabbit
}
export(ANIMALS) var animal = ANIMALS.Elephant

var flipped = true

var index = -1
var solved = false

onready var anim = $AnimationPlayer

func _ready():
	updateSprite()
	flipped = true

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		if flipped and not anim.is_playing():
			anim.play("flip_to_front")
			flipped = false
			yield(get_tree().create_timer(0.5), "timeout")
			var last = GM.cards[GM.lastCard]
			if GM.lastCard == -1:
				GM.lastCard = index
			else:
				GM.lastCard = -1
				if last.animal == animal:
					last.anim.play("solved")
					anim.play("solved")
					yield(get_tree().create_timer(0.5), "timeout")
					last.solved = true
					solved = true
					GM.solvedCount += 2
					GM.solvedCheck()
				else:
					yield(get_tree().create_timer(0.5), "timeout")
					last.anim.play("flip_to_back")
					anim.play("flip_to_back")
					last.flipped = true
					flipped = true

func updateSprite():
	$Sprite.texture = load("res://sprites/" + str(animal) + ".png")
