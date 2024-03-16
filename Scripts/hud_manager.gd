extends Control

@onready var coins_counter = $ContainerMargin/CoinContainer/Coins_counter as Label
@onready var score_label = $ContainerMargin/ScoreContainer/ScoreLabel as Label
@onready var score_points = $ContainerMargin/ScoreContainer/ScorePoints as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_points.text = str("%06d" % Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if str(Globals.coins) != coins_counter.text:
		coins_counter.text = str("%04d" % Globals.coins)
	if str(Globals.score) != score_points.text:
		score_points.text = str("%06d" % Globals.score)
