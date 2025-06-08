extends Node2D

@onready var checkpoint_1: Checkpoint = $checkpoint1
@onready var checkpoint_2: Checkpoint = $checkpoint2
@onready var marker_2d: Marker2D = $Marker2D

var checkpoint_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_list = [
		marker_2d,
		checkpoint_1,
		checkpoint_2
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
