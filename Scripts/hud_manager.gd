extends Control

@onready var coins_counter = $ContainerMargin/CoinContainer/Coins_counter as Label
@onready var score_label = $ContainerMargin/ScoreContainer/ScoreLabel as Label
@onready var score_points = $ContainerMargin/ScoreContainer/ScorePoints as Label
@onready var time_counter = $ContainerMargin/TimeContainer/Time_counter as Label
@onready var clock_time = $clock_time as Timer

var minutes := 0
var seconds := 0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	time_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
	score_points.text = str("%06d" % Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if str(Globals.coins) != coins_counter.text:
		coins_counter.text = str("%04d" % Globals.coins)
	if str(Globals.score) != score_points.text:
		score_points.text = str("%06d" % Globals.score)
	time_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)


func _on_clock_time_timeout():
	if seconds >= 59:
		minutes += 1
		seconds = 0
	else:
		seconds += 1
