extends Node

signal gained_coins(int)
signal health_changed()
var coins : int
var current_checkpoint: Checkpoint
var player : Player
var is_dialogue_active = false
var level_portal_active = false
var knows_npc_lvl1 = false
var knows_npc_lvl2 = false
var player_health = 0
var player_max_health = 100
var checkpoint_counter=0
var dissapear_npc2 = false

func respawn_player():
	if current_checkpoint != null:
		player_health = player_max_health
		player.can_die = true
		player.attacking = false
		player.velocity = Vector2.ZERO
		player.position = current_checkpoint.global_position

func gain_coins(coins_gained:int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	print("Coins gained: ",coins)
	
func take_coins(coins_gained:int):
	coins -= coins_gained
	emit_signal("gained_coins", coins_gained)
	print("Coins gained: ",coins)
