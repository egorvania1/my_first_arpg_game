extends Node2D

@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $TileMap/Player

func _ready():
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
