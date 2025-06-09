extends Node


signal partidas_recibidas(partidas)
signal progreso_recibido(progresos)

# ... resto de ApiManager.gd ...

# Variables públicas accesibles
var datos_por_jugador: Dictionary = {}

# Control interno de peticiones en curso
var _en_proceso: Dictionary = {}

func _ready():
	ApiManager.partidas_recibidas.connect(_procesar_partidas)
	ApiManager.progreso_recibido.connect(_procesar_progreso)

func obtener_monedas_jugador(id_jugador: int) -> int:
	_solicitar_datos_si_no_existen(id_jugador)
	return datos_por_jugador.get(id_jugador, {}).get("monedas", -1)

func obtener_nivel_actual_jugador(id_jugador: int) -> int:
	_solicitar_datos_si_no_existen(id_jugador)
	return datos_por_jugador.get(id_jugador, {}).get("nivel_actual", -1)

func obtener_checkpoint_jugador(id_jugador: int) -> int:
	_solicitar_datos_si_no_existen(id_jugador)
	return datos_por_jugador.get(id_jugador, {}).get("checkpoint", -1)

func obtener_enemigos_derrotados_jugador(id_jugador: int) -> int:
	_solicitar_datos_si_no_existen(id_jugador)
	return datos_por_jugador.get(id_jugador, {}).get("enemigos_derrotados", -1)

func obtener_jefe_derrotado_jugador(id_jugador: int) -> bool:
	_solicitar_datos_si_no_existen(id_jugador)
	return datos_por_jugador.get(id_jugador, {}).get("jefe_derrotado", false)

# Lanzar carga si no existe
func _solicitar_datos_si_no_existen(id_jugador: int):
	if datos_por_jugador.has(id_jugador):
		return
	if _en_proceso.has(id_jugador):
		return
	
	_en_proceso[id_jugador] = true
	ApiManager.leer_partidas_por_jugador(id_jugador)

func _procesar_partidas(partidas: Array):
	if partidas.is_empty():
		return

	var id_jugador = partidas[0].get("id_jugador", -1)
	if id_jugador == -1:
		return

	# Más reciente
	partidas.sort_custom(func(a, b): return a["id_partida"] > b["id_partida"])
	var id_partida = partidas[0].get("id_partida", -1)

	if id_partida > 0:
		_en_proceso[id_jugador] = id_partida
		ApiManager.leer_progreso_por_partida(id_partida)

func _procesar_progreso(progresos: Array):
	if progresos.is_empty():
		return

	progresos.sort_custom(func(a, b): return a["id_progreso"] > b["id_progreso"])
	var progreso = progresos[0]
	var id_partida = progreso.get("id_partida", -1)
	if id_partida == -1:
		return

	# Buscar qué jugador solicitó esto
	for id_jugador in _en_proceso.keys():
		if _en_proceso[id_jugador] == id_partida:
			datos_por_jugador[id_jugador] = progreso
			_en_proceso.erase(id_jugador)
			break
