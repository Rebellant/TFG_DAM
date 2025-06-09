extends Node

var progreso_guardado: Dictionary = {}

func _ready():
	ApiManager.progreso_recibido.connect(_cuando_llega_el_progreso)
	ApiManager.leer_progreso_por_partida(1)  # Cambia a tu ID real

func _cuando_llega_el_progreso(progresos: Array):
	if progresos.size() == 0:
		print("No se encontró progreso.")
		return

	var progreso = progresos[0]  # Solo usamos el primero
	progreso_guardado = progreso  # Lo guardamos por si lo necesitas luego

	print("Nivel actual:", progreso["nivel_actual"])
	print("Checkpoint:", progreso["checkpoint"])
	print("Monedas:", progreso["monedas"])
	print("Enemigos derrotados:", progreso["enemigos_derrotados"])
	print("¿Jefe derrotado?:", progreso["jefe_derrotado"] == 1)

	# Ejemplo: cambiar de escena según nivel
	# get_tree().change_scene_to_file("res://niveles/Nivel%d.tscn" % progreso["nivel_actual"])
