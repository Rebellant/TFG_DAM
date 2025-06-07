extends Node2D

@export var player : Player


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		GameManager.player_health += 50
		if GameManager.player_health > GameManager.player_max_health:
			GameManager.player_health = GameManager.player_max_health
		GameManager.health_changed.emit()
		queue_free()
