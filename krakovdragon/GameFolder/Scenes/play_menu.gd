extends Control

var nivel_actual := 1
var checkpoint := 1
var monedas := 0
var enemigos_derrotados := 0
var jefe_derrotado := false
var datos_listos := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ApiManager.progreso_recibido.connect(_cuando_llega_el_progreso) #PARA LEER
	ApiManager.leer_progreso_por_partida(1)  # Cambia a tu ID real PARA LEER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#GameManager.final_boss_dead = jefe
#GameManager.coins = 
#GameManager.checkpoint_counter 
#GameManager.player_in_lvl 
#GameManager.enemies_killed 

func _on_btn_new_game_pressed():
	actualizar_datos_new_game()
	await get_tree().create_timer(2).timeout
	GameManager.final_boss_dead = jefe_derrotado
	GameManager.coins = monedas
	GameManager.checkpoint_counter = checkpoint
	GameManager.player_in_lvl = nivel_actual
	GameManager.enemies_killed = enemigos_derrotados
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")


func _on_btn_continue_pressed():
	if not datos_listos:
		print("Los datos aún no están listos")
		return

	get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_%d.tscn" % GameManager.player_in_lvl)
	

func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://GameFolder/Scenes/menu.tscn")

func actualizar_datos_new_game(): #ACTUALIZAR DATOS
	var datos_actualizados = {
		"id_partida": 1,
		"id_progreso": 1,
		"nivel_actual": 1,
		"checkpoint": 1,
		"monedas": 0,
		"enemigos_derrotados": 0,
		"jefe_derrotado": 0
	}
	ApiManager.actualizar_progreso(datos_actualizados)

func _cuando_llega_el_progreso(progresos: Array):
	if progresos.size() == 0:
		print("No se encontró progreso.")
		datos_listos = false
		return

	var progreso = progresos[0]

	# Guardar en variables locales
	nivel_actual = progreso["nivel_actual"]
	checkpoint = progreso["checkpoint"]
	monedas = progreso["monedas"]
	enemigos_derrotados = progreso["enemigos_derrotados"]
	jefe_derrotado = progreso["jefe_derrotado"] == 1

	# Guardar en GameManager para uso global
	GameManager.final_boss_dead = jefe_derrotado
	GameManager.coins = monedas
	GameManager.checkpoint_counter = checkpoint
	GameManager.player_in_lvl = nivel_actual
	GameManager.enemies_killed = enemigos_derrotados

	datos_listos = true
	print("✅ Progreso cargado correctamente")
