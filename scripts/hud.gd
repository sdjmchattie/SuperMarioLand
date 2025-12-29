extends CanvasLayer

@onready var score_label: RichTextLabel = $Score
@onready var lives_label: RichTextLabel = $Lives
@onready var time_label: RichTextLabel = $Time
@onready var coins_label: RichTextLabel = $Coins

func _ready():
	# Persistent game state
	GameState.score_changed.connect(_on_score_changed)
	GameState.lives_changed.connect(_on_lives_changed)
	GameState.time_changed.connect(_on_time_changed)
	GameState.coins_changed.connect(_on_coins_changed)

	# Initial draw
	_on_score_changed(GameState.score)
	_on_lives_changed(GameState.lives)
	_on_time_changed(GameState.time_remaining)
	_on_coins_changed(GameState.coins)

func _on_score_changed(score: int):
	score_label.text = "%d" % score

func _on_lives_changed(lives: int):
	lives_label.text = "%02d" % lives

func _on_time_changed(time: int):
	time_label.text = "%03d" % time

func _on_coins_changed(coins: int):
	coins_label.text = "%02d" % coins
