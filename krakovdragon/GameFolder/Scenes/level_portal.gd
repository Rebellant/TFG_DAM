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
	if area.get_parent() is Player:
		print("Hello portal!")
