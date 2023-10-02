extends Node2D

var UNITS = preload("res://Resources/Units.tres")

@onready var attack_timer = $AttackTimer
@onready var animation_player = $AnimationPlayer

# Health. 
@export var max_hp: int = 100
@onready var hp: int = max_hp:
	set = set_hp 
signal hp_changed(val)

var broken = false 
	
func set_hp(new_hp):	
	var old_hp = hp 
	hp = clamp(new_hp, 0, max_hp) 
	if old_hp == hp:
		return
	# Send a signal to the UI to update the players HP. 
	emit_signal("hp_changed", hp)

func _ready():
	UNITS.enemy = self
	
func _exit_tree():
	UNITS.enemy = null


func _on_attack_timer_timeout():
	attack_logic()

# Randomly decide which direction to attack the player. 
func attack_logic(): 
	if broken:
		return 
	
	var player = UNITS.player
	if not player: 
		print("There is no player to attack.")
		return
	
	# Randomly attack left or right. 
	randomize()
	var r = randi_range(0, 1)
	
	# Attack left. 
	if r == 0: 
		animation_player.play("attack_left")
	#Attack right. 
	else: 
		animation_player.play("attack_right")

# The animation has contacted the player. Attack! 
func attack_player(direction: String): 
	UNITS.player.getting_attacked(direction)  # Direction HAS to be left or right! No typos. 

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "broken":
		pass
	else: 
		animation_player.play("RESET")

func take_damage(damage: int):
	if broken: 
		damage *= 2
	hp -= damage
	
func attack_break(): 
	broken = true
	animation_player.play("broken")
	await get_tree().create_timer(3.25).timeout 
	
	animation_player.play("RESET")
	broken = false
