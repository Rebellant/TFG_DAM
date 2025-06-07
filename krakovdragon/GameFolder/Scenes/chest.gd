extends Node2D

var counter = 0

func _on_area_2d_area_entered(area):
	if counter == 0:
		counter += 1
		$AnimationPlayer.play("open_chest")
		$AnimationPlayer2.play("coin_rotation")
		await $AnimationPlayer2.animation_finished
		$CoinSprite2D.queue_free()
		GameManager.gain_coins(20)
	elif counter == 0:
		$AnimationPlayer.play("opened_chest")
		await $AnimationPlayer.animation_finished
		GameManager.gain_coins(0)
		
		
		
