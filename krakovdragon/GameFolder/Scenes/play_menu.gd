extends Control

var nivel_actual := 1
var checkpoint := 0
var monedas := 0
var enemigos_derrotados := 0
var jefe_derrotado := false
var datos_listos := false
var creando_partida_nueva := false

func _ready() -> void:
	ApiManager.progreso_recibido.connect(_cuando_llega_el_progreso)
	ApiManager.progreso_actualizado.connect(_cuando_actualizado)
	ApiManager.leer_progreso_por_partida(1)

func _on_btn_new_game_pressed():
	creando_partida_nueva = true
	actualizar_datos_new_game()

func _on_btn_continue_pressed():
	if not datos_listos:
		print("❌ Los datos aún no están listos")
		return
	get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_%d.tscn" % GameManager.player_in_lvl)

func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://GameFolder/Scenes/menu.tscn")

func actualizar_datos_new_game():
	var datos_actualizados = {
		"id_partida": 1,
		"id_progreso": 1,
		"nivel_actual": 1,
		"checkpoint": 0,
		"monedas": 0,
		"enemigos_derrotados": 0,
		"jefe_derrotado": 0
	}
	ApiManager.actualizar_progreso(datos_actualizados)

func _cuando_actualizado():
	print("✅ Confirmado: progreso actualizado en base de datos")

	if creando_partida_nueva:
		# Resetear GameManager
		GameManager.final_boss_dead = false
		GameManager.coins = 0
		GameManager.checkpoint_counter = 0
		GameManager.player_in_lvl = 1
		GameManager.enemies_killed = 0

		# Cambiar de escena solo tras confirmación
		get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")

func _cuando_llega_el_progreso(progresos: Array):
	if progresos.is_empty():
		print("⚠️ No se encontró progreso.")
		datos_listos = false
		return

	var progreso = progresos[0]
	nivel_actual = progreso["nivel_actual"]
	checkpoint = progreso["checkpoint"]
	monedas = progreso["monedas"]
	enemigos_derrotados = progreso["enemigos_derrotados"]
	jefe_derrotado = progreso["jefe_derrotado"] == 1

	# Guardar en GameManager
	GameManager.final_boss_dead = jefe_derrotado
	GameManager.coins = monedas
	GameManager.checkpoint_counter = checkpoint
	GameManager.player_in_lvl = nivel_actual
	GameManager.enemies_killed = enemigos_derrotados

	datos_listos = true
	print("✅ Progreso cargado:", progreso)
