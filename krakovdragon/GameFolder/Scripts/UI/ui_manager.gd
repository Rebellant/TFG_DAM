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
	


func _on_btn_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://GameFolder/Scenes/menu.tscn")

func _on_btn_save_pressed() -> void:
	var datos_actualizados = {
		"id_partida": 1,    
		"id_progreso": 1,    
		"nivel_actual": GameManager.player_in_lvl,
		"checkpoint": GameManager.checkpoint_counter,
		"monedas": GameManager.coins,
		"enemigos_derrotados": GameManager.enemies_killed,
		"jefe_derrotado": GameManager.final_boss_dead
	}

	ApiManager.actualizar_progreso(datos_actualizados)
	print("Progreso guardado.")
