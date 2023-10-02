extends "res://Scenes/UI/health_bar.gd"

var UNITS = preload("res://Resources/Units.tres")

var player 

func _ready():
	# Check if there is a player. 
	player = UNITS.player
	if not player:
		return 
	
	# Initiliaze health bar with players hp. 
	max_value = player.max_hp
	value = player.hp

	player.hp_changed.connect(_on_player_hp_changed)

# The players HP has changed. Update the health bar. 
func _on_player_hp_changed(hp):
	value = hp
		
