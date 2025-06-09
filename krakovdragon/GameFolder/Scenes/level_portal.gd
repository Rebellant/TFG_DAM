extends Node2D

var counter = 1
func _process(delta):
	if GameManager.level_portal_active == false:
		$AnimatedSprite2D.hide()
		$Hitbox/CollisionShape2D.disabled = true
	if GameManager.level_portal_active == true:
		$AnimatedSprite2D.play("portal_on")
		$Hitbox/CollisionShape2D.disabled = false
		$AnimatedSprite2D.show()

func _on_hitbox_area_entered(area):
	
	if counter == 1:
		get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_2.tscn")
	elif counter == 2:
		get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_3.tscn")
