extends Node

var progreso_guardado: Dictionary = {}

func _ready():
	ApiManager.progreso_recibido.connect(_cuando_llega_el_progreso) #PARA LEER
	ApiManager.leer_progreso_por_partida(1)  # Cambia a tu ID real PARA LEER
	actualizar_datos()
func borrar_progreso_Partida():
	ApiManager.borrar_progreso(8)  # Cambia por el ID real que quieras eliminar


func actualizar_datos(): #ACTUALIZAR DATOS
	var datos_actualizados = {
		"id_partida": 1,
		"id_progreso": 7,
		"nivel_actual": 1,
		"checkpoint": 1,
		"monedas": 300,
		"enemigos_derrotados": 4,
		"jefe_derrotado": 0
	}
	ApiManager.actualizar_progreso(datos_actualizados)


func guardar_datos(): #INSERTAR DATOS
	var datos = {
		"id_partida": 1,
		"nivel_actual": 3,
		"checkpoint": 3,
		"monedas": 150,
		"enemigos_derrotados": 10,
		"jefe_derrotado": 1
		
	}
	ApiManager.guardar_progreso(datos)

func _cuando_llega_el_progreso(progresos: Array):
	if progresos.size() == 0:
		print("No se encontró progreso.")
		return
	var progreso = progresos[0]
	print("Nivel actual:", progreso["nivel_actual"])
	print("Checkpoint:", progreso["checkpoint"])
	print("Monedas:", progreso["monedas"])
	print("Enemigos derrotados:", progreso["enemigos_derrotados"])
	print("¿Jefe derrotado?:", progreso["jefe_derrotado"] == 1)
	 
 #Ejemplo: cambiar de escena según nivel
 #get_tree().change_scene_to_file("res://niveles/Nivel%d.tscn" % progreso["nivel_actual"])
