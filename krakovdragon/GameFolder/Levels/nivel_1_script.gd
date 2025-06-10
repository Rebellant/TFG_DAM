extends Node2D

@onready var checkpoint_1: Checkpoint = $checkpoint1
@onready var checkpoint_2: Checkpoint = $checkpoint2
@onready var marker_2d: Marker2D = $Marker2D
@onready var player: Player = $Player 

var checkpoint_list: Array

func _ready() -> void:
	# Lista de checkpoints (el índice debe coincidir con checkpoint_counter)
	checkpoint_list = [
		checkpoint_1,
		checkpoint_2
	]


func move_player_to_spawnpoint(indice: int) -> void:
	player.global_position = checkpoint_list[indice].global_position
