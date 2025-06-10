extends Node2D

@onready var checkpoint_1: Checkpoint = $checkpoint1
@onready var checkpoint_2: Checkpoint = $checkpoint2
@onready var marker_2d: Marker2D = $Marker2D
@onready var player: Player = $Player 

var checkpoint_list: Array

func _ready() -> void:
	# Lista de checkpoints (el índice debe coincidir con checkpoint_counter)
	checkpoint_list = [
		marker_2d,
		checkpoint_1,
		checkpoint_2
	]

	var checkpoint_guardado = GameManager.checkpoint_counter

	if checkpoint_guardado >= 0 and checkpoint_guardado < checkpoint_list.size():
		move_player_to_spawnpoint(checkpoint_guardado)
	else:
		move_player_to_spawnpoint(0)

func move_player_to_spawnpoint(indice: int) -> void:
	player.global_position = checkpoint_list[indice].global_position
