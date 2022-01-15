extends Node

var newGame = true
var playButton

var cards = []
var unassigned = []
var lastCard = -1
var solvedCount = 0

const CardRes = preload("res://Card.tscn")
const ConfettiRes = preload("res://Confetti.tscn")

func _ready():
	print("Game Manager loaded!")

func create():
	randomize()

	for i in 16:
		var card = CardRes.instance()

		card.position = calcPosition(i)
		card.index = i
		cards.append(card)
		
		unassigned.append(i)

		self.add_child(card)

	for i in 8:
		for j in 2:
			var randPicked = randi() % len(unassigned)

			var card = cards[unassigned[randPicked]]
			card.animal = i
			card.updateSprite()

			unassigned.remove(randPicked)

func calcPosition(index):
	var spacing = 160
	return Vector2(240, 240) + Vector2(index % 4 * spacing, floor(index / 4) * spacing)

func reset():
	for card in cards:
		card.anim.play("destroy")
	
	yield(get_tree().create_timer(0.5), "timeout")

	for card in cards:
		card.queue_free()
	
	cards = []
	unassigned = []
	lastCard = -1
	solvedCount = 0

	create()

func solvedCheck():
	if solvedCount == len(cards):
		for card in cards:
			card.anim.play("solved")
			yield(get_tree().create_timer(0.01), "timeout")
		print("Solved!")
		yield(get_tree().create_timer(0.5), "timeout")
		confetti()
		playButton.GAnim.play("show-play-button")

func confetti():
	var left = ConfettiRes.instance()
	var right = ConfettiRes.instance()

	left.position = Vector2(0, 1080)
	right.position = Vector2(1920, 1080)

	left.z_index = 1000
	right.z_index = 1000
	
	right.scale.x = -1
	
	self.add_child(left)
	self.add_child(right)
	
	left.emitting = true
	right.emitting = true
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	left.queue_free()
	right.queue_free()
