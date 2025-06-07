extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false

func _ready():
	if spawnpoint:
		activate()

func activate():
	GameManager.checkpoint_counter +=1
	GameManager.current_checkpoint = self
	activated = true
	$AnimatedSprite2D.play("checkpoint_activated")
	await ($AnimatedSprite2D.animation_finished)
	$AnimatedSprite2D.play("checkpoint_default_activated")
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player") and not activated:
		activate()
