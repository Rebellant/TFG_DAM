extends Node2D

@export var player : Player
@export var float_amplitude: float = 2
@export var float_speed: float = 0.8      
var base_y: float = 0.0
var time_passed: float = 0.0

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		GameManager.player_health += 50
		if GameManager.player_health > GameManager.player_max_health:
			GameManager.player_health = GameManager.player_max_health
		GameManager.health_changed.emit()
		queue_free()

func _ready():
	base_y = global_position.y  # Guarda la posición Y inicial

func _process(delta):
	time_passed += delta
	var offset_y = sin(time_passed * float_speed) * float_amplitude
	global_position.y = base_y + offset_y
