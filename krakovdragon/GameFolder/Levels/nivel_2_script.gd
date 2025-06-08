extends Node2D

@onready var marker_2d: Marker2D = $CheckpointHolder/Marker2D
@onready var checkpoint_1: Checkpoint = $CheckpointHolder/checkpoint1
@onready var checkpoint_2: Checkpoint = $CheckpointHolder/checkpoint2
@onready var checkpoint_3: Checkpoint = $CheckpointHolder/checkpoint3
@onready var checkpoint_4: Checkpoint = $CheckpointHolder/checkpoint4
@onready var player: Player = $Player


var checkpoint_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_list = [
		marker_2d,
		checkpoint_1,
		checkpoint_2,
		checkpoint_3,
		checkpoint_4
	]
	GameManager.checkpoint_counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_player_to_spawnpoint(indice:int):
	player.global_position=checkpoint_list[indice].global_position
