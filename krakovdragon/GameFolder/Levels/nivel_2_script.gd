extends Node2D

@onready var checkpoint_1: Checkpoint = $checkpoint1
@onready var checkpoint_2: Checkpoint = $checkpoint2
@onready var checkpoint_3: Checkpoint = $checkpoint3
@onready var checkpoint_4: Checkpoint = $checkpoint4
@onready var player: Player = $Player


var checkpoint_list: Array
var player_moved := false

func _process(delta):
	if not player_moved and player != null:
		var index = GameManager.checkpoint_counter
		if index >= 0 and index < checkpoint_list.size():
			move_player_to_spawnpoint(index)
		else:
			move_player_to_spawnpoint(0)
		player_moved = true

func _ready() -> void:
	# Lista de posiciones posibles de respawn
	checkpoint_list = [
		checkpoint_1,
		checkpoint_2,
		checkpoint_3,
		checkpoint_4
	]


func move_player_to_spawnpoint(indice: int):

		player.global_position = checkpoint_list[indice].global_position
