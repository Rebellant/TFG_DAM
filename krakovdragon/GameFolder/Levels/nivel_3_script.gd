extends Node2D

@onready var checkpoint: Checkpoint = $checkpoint
@onready var checkpoint_2: Checkpoint = $checkpoint2
@onready var player: Player = $Player

var checkpoint_list: Array

func _ready() -> void:
	# Lista de checkpoints en orden
	checkpoint_list = [
		checkpoint,
		checkpoint_2
	]

	# Obtener el checkpoint guardado
	var checkpoint_guardado = GameManager.checkpoint_counter

	# Validar y mover jugador
	if checkpoint_guardado >= 0 and checkpoint_guardado < checkpoint_list.size():
		move_player_to_spawnpoint(checkpoint_guardado)
	else:
		move_player_to_spawnpoint(0)

func move_player_to_spawnpoint(indice: int) -> void:
	if player.global_position == null:
		player.global_position = checkpoint_list[indice].global_position
