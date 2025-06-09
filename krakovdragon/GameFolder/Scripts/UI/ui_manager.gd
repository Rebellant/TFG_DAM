extends CanvasLayer



func _ready():
	$HealthBar.min_value = 0
	$HealthBar.max_value = GameManager.player_max_health
	GameManager.gained_coins.connect(update_coin_display)
	GameManager.pause_menu = $PauseMenu


	
func _process(_delta):
	$HealthBar.value = GameManager.player_health
	$CoinDisplay.text = str(GameManager.coins)
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_play()
		
	
func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManager.coins)


func _on_btn_resume_pressed() -> void:
	GameManager.pause_play()


func _on_btn_save_pressed() -> void:
	pass # Replace with function body.


func _on_btn_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://GameFolder/Scenes/menu.tscn")
