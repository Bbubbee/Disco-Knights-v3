extends "res://Scenes/UI/health_bar.gd"

var UNITS = preload("res://Resources/Units.tres")

var enemy 

func _ready():
	# Check if there is a player. 
	enemy = UNITS.enemy
	if not enemy:
		return 
	
	# Initiliaze health bar with players hp. 
	max_value = enemy.max_hp
	value = enemy.hp

	enemy.hp_changed.connect(_on_enemy_hp_changed)

# The players HP has changed. Update the health bar. 
func _on_enemy_hp_changed(hp):
	value = hp
		
