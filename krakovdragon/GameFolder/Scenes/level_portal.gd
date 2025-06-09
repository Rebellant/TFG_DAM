extends Node2D


func _process(delta):
	if GameManager.level_portal_active == false:
		$AnimatedSprite2D.hide()
		$Hitbox/CollisionShape2D.disabled = true
	if GameManager.level_portal_active == true:
		$AnimatedSprite2D.play("portal_on")
		$Hitbox/CollisionShape2D.disabled = false
		$AnimatedSprite2D.show()

func _on_hitbox_area_entered(area):
	
	if GameManager.player_in_lvl == 1:
		get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")
	if GameManager.player_in_lvl == 2:
		get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_2.tscn")
	if GameManager.player_in_lvl == 3:
		get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_3.tscn")
