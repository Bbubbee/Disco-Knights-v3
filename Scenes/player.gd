extends Node2D

"""
TODO: 
	- Attack timer. So player can't spam attacks/parries. 
"""

var UNITS = preload("res://Resources/Units.tres")
var PARRY_ANIMATION = preload("res://Scenes/VFX/parry_animation.tscn")

@onready var parry_timer = $ParryTimer  # How long an attack can be parried before dealing damage. 
@onready var animation_player = $AnimationPlayer

var can_parry = false
var parry_window = 0  # The time a player gets to parry.   
var parry_direction   # The direction you have to attack to parry. 
var parried = false 
var parry_counter = 0  # Parry 3 times = break enemies defences!

# Health. 
@export var max_hp: int = 100
@onready var hp: int = max_hp:
	set = set_hp 
signal hp_changed(val)
	
func set_hp(new_hp):
	var old_hp = hp 
	hp = clamp(new_hp, 0, max_hp) 
	if old_hp == hp:
		return
	# Send a signal to the UI to update the players HP. 
	emit_signal("hp_changed", hp)

	
func _ready():
	UNITS.player = self
	
func _exit_tree():
	UNITS.player = null
	
func _process(_delta):
	if Input.is_action_just_pressed("player_left"):
		attack_animation("left")
	if Input.is_action_just_pressed("player_right"):
		attack_animation("right")
		
	# Check if can parry break enemy. 
	if parry_counter >= 3: 
		break_enemy()

# The enemy has broken the enemy, allowing a brief window of attack.
func break_enemy(): 
	parry_counter = 0
	var enemy = UNITS.enemy
	if enemy: 
		enemy.attack_break()

# The player is trying to winding up for an attack. 
func attack_animation(direction: String):
	# Attack animation. 
	if direction == "left": 
		animation_player.play("attack_left")
	else:
		animation_player.play("attack_right")

# The player is getting attacked by an enemy. 
# Allow a brief parry window. 
func getting_attacked(direction: String):
	print("Uh oh! Enemy attacks from the "+direction) 
	parry_direction = direction
	can_parry = true
	parry_timer.start()

# Parry window is over! Take damage from the attack. 
func _on_parry_timer_timeout():
	if not parried: 
		hp -= 12
	parried = false
	can_parry = false


func _on_animation_player_animation_finished(_anim_name):
	animation_player.play("RESET")
	

# The player will deal damage when the animation has attacked the enemy. 
func attack_enemy(direction: String):
	var enemy = UNITS.enemy
		
	# Check if there is an attack to parry. If there isn't, just deal chip damage to enemy. 
	if not can_parry:
		if UNITS.enemy:
			enemy.take_damage(randi_range(1, 3))
		return
	
	# Check if the parry was in the right direction. 
	if direction == parry_direction: 
		print("Parried!")
		parried = true
		can_parry = false 
		parry_counter += 1
		
		# Play parry animation.
		var parry_animation = PARRY_ANIMATION.instantiate()
		parry_animation.position.y -= 15
		add_child(parry_animation)
	else:
		print("Parried in wrong direction!")




