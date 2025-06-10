extends Node
#UI SIGNALS
signal gained_coins(int)
signal health_changed()

#OTHER VARS
var player : Player
var paused = false
var pause_menu

# TRIGGER VARS
var is_dialogue_active = false
var level_portal_active = false
var knows_npc_lvl1 = false
var knows_npc_lvl2 = false
var player_health = 0
var player_max_health = 180
var dissapear_npc2 = false

#GAME PROGRESS VARS
var final_boss_dead = false
var coins : int
var checkpoint_counter=0
var player_in_lvl=1
var enemies_killed : int

var current_checkpoint: Checkpoint

#FUNCS
func _ready():
	set_process_mode(Node.PROCESS_MODE_WHEN_PAUSED)

func _process(delta):
	print("GameManager activo durante pausa")

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

#PAUSE MENU LOGIC
func pause_play():
		paused = !paused
		pause_menu.visible = paused

func resume():
	pause_play()
	pause_menu.visible = false

func save():
	pass

func main_menu():
	get_tree().change_scene_to_file("res://GameFolder/Scenes/menu.tscn")
