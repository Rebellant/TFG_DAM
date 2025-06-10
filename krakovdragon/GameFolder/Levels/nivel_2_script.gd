extends Node2D

@onready var marker_2d: Marker2D = $CheckpointHolder/Marker2D
@onready var checkpoint_1: Checkpoint = $CheckpointHolder/checkpoint1
@onready var checkpoint_2: Checkpoint = $CheckpointHolder/checkpoint2
@onready var checkpoint_3: Checkpoint = $CheckpointHolder/checkpoint3
@onready var checkpoint_4: Checkpoint = $CheckpointHolder/checkpoint4
@onready var player: Player = $Player

var checkpoint_list: Array

func _ready() -> void:
	# Lista de posiciones posibles de respawn
	checkpoint_list = [
		marker_2d,
		checkpoint_1,
		checkpoint_2,
		checkpoint_3,
		checkpoint_4
	]

	# Leer checkpoint desde GameManager y mover al jugador
	var checkpoint_guardado = GameManager.checkpoint_counter

	if checkpoint_guardado >= 0 and checkpoint_guardado < checkpoint_list.size():
		move_player_to_spawnpoint(checkpoint_guardado)
	else:
		move_player_to_spawnpoint(0)  # Fallback en caso de error

func move_player_to_spawnpoint(indice: int):
	player.global_position = checkpoint_list[indice].global_position
