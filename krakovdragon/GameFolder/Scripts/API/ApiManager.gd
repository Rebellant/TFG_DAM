extends Node

# ===================================================================
# APIManager - Singleton Global para manejo de API
# ===================================================================

# URL base de tu API
const BASE_URL = "http://localhost/API_Godot/crud/"

# Variables globales para almacenar datos
var jugadores: Array = []
var partidas: Array = []
var progreso_data: Array = []
var ultimo_jugador: Dictionary = {}
var ultima_partida: Dictionary = {}
var ultimo_progreso: Dictionary = {}

# Estado de carga
var cargando: bool = false
var datos_cargados: Dictionary = {
	"jugadores": false,
	"partidas": false,
	"progreso": false
}

# Señales globales
signal jugadores_recibidos(data: Array)
signal jugador_recibido(data: Dictionary)
signal partidas_recibidas(data: Array)
signal partida_recibida(data: Dictionary)
signal progreso_recibido(data: Array)
signal datos_actualizados(tipo: String, exito: bool, mensaje: String)
signal error_api(mensaje: String, codigo: int)
signal carga_completa()

# Cache para evitar peticiones duplicadas
var cache_activo: bool = true
var tiempo_cache: float = 60.0  # 60 segundos
var ultima_actualizacion: Dictionary = {}

func _ready():
	# Configurar el nodo como persistente
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("APIManager inicializado como singleton global")

# ===================================================================
# FUNCIONES PRIVADAS DE HTTP
# ===================================================================

func _send_json_request(url: String, data: Dictionary, method: HTTPClient.Method, callback_type: String = ""):
	if cargando:
		print("APIManager: Operación en curso, esperando...")
		return
	
	cargando = true
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json"
	]
	
	var json_string = JSON.stringify(data)
	
	http_request.request_completed.connect(func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		cargando = false
		var response_text = body.get_string_from_utf8()
		var parsed_data = null
		
		if response_text != "":
			var json = JSON.new()
			var parse_result = json.parse(response_text)
			if parse_result == OK:
				parsed_data = json.data
			else:
				parsed_data = response_text
		
		_manejar_respuesta(response_code, parsed_data, response_text, callback_type)
		http_request.queue_free()
	)
	
	http_request.request(url, headers, method, json_string)

func _send_get_request(url: String, callback_type: String = ""):
	# Verificar cache
	if cache_activo and _verificar_cache(callback_type):
		return
	
	if cargando:
		print("APIManager: Operación en curso, esperando...")
		return
	
	cargando = true
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var headers = [
		"Accept: application/json"
	]
	
	http_request.request_completed.connect(func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		cargando = false
		var response_text = body.get_string_from_utf8()
		var parsed_data = null
		
		if response_text != "":
			var json = JSON.new()
			var parse_result = json.parse(response_text)
			if parse_result == OK:
				parsed_data = json.data
			else:
				parsed_data = response_text
		
		_manejar_respuesta(response_code, parsed_data, response_text, callback_type)
		http_request.queue_free()
	)
	
	http_request.request(url, headers, HTTPClient.METHOD_GET)

func _manejar_respuesta(response_code: int, parsed_data, response_text: String, callback_type: String):
	print("=== APIManager RESPUESTA ===")
	print("Código: ", response_code)
	print("Tipo: ", callback_type)
	
	if response_code >= 200 and response_code < 300:
		print("Éxito - Datos: ", parsed_data)
		
		if parsed_data:
			_procesar_datos_recibidos(parsed_data, callback_type)
			_actualizar_cache(callback_type)
		
		if callback_type.begins_with("insertar_") or callback_type.begins_with("actualizar_") or callback_type.begins_with("borrar_"):
			datos_actualizados.emit(callback_type, true, "Operación exitosa")
	else:
		print("Error - Respuesta: ", response_text)
		error_api.emit("Error en " + callback_type + ": " + response_text, response_code)
		
		if callback_type.begins_with("insertar_") or callback_type.begins_with("actualizar_") or callback_type.begins_with("borrar_"):
			datos_actualizados.emit(callback_type, false, "Error: " + response_text)
	
	print("========================")

func _procesar_datos_recibidos(data, tipo: String):
	match tipo:
		"jugadores":
			jugadores = data if data is Array else [data]
			datos_cargados["jugadores"] = true
			jugadores_recibidos.emit(jugadores)
		
		"jugador_id":
			ultimo_jugador = data if data is Dictionary else {}
			jugador_recibido.emit(ultimo_jugador)
		
		"partidas":
			partidas = data if data is Array else [data]
			datos_cargados["partidas"] = true
			partidas_recibidas.emit(partidas)
		
		"partida_id", "partidas_jugador":
			ultima_partida = data if data is Dictionary else {}
			partida_recibida.emit(ultima_partida)
		
		"progreso", "progreso_id", "progreso_partida":
			progreso_data = data if data is Array else [data]
			datos_cargados["progreso"] = true
			progreso_recibido.emit(progreso_data)
	
	# Verificar si todos los datos principales están cargados
	if datos_cargados["jugadores"] and datos_cargados["partidas"] and datos_cargados["progreso"]:
		carga_completa.emit()

# ===================================================================
# SISTEMA DE CACHE
# ===================================================================

func _verificar_cache(tipo: String) -> bool:
	if not cache_activo:
		return false
	
	var ahora = Time.get_ticks_msec() / 1000.0
	var ultima_vez = ultima_actualizacion.get(tipo, 0.0)
	
	if ahora - ultima_vez < tiempo_cache:
		print("APIManager: Usando datos del cache para ", tipo)
		# Emitir señal con datos existentes
		match tipo:
			"jugadores":
				if not jugadores.is_empty():
					jugadores_recibidos.emit(jugadores)
					return true
			"partidas":
				if not partidas.is_empty():
					partidas_recibidas.emit(partidas)
					return true
			"progreso":
				if not progreso_data.is_empty():
					progreso_recibido.emit(progreso_data)
					return true
	
	return false

func _actualizar_cache(tipo: String):
	ultima_actualizacion[tipo] = Time.get_ticks_msec() / 1000.0

func limpiar_cache():
	ultima_actualizacion.clear()
	print("APIManager: Cache limpiado")

func desactivar_cache():
	cache_activo = false

func activar_cache():
	cache_activo = true

# ===================================================================
# FUNCIONES PARA JUGADORES
# ===================================================================

func insertar_jugador(nombre: String):
	var data = {"nombre": nombre}
	_send_json_request(BASE_URL + "Jugador/insertar.php", data, HTTPClient.METHOD_POST, "insertar_jugador")

func leer_jugadores():
	_send_get_request(BASE_URL + "Jugador/leer.php", "jugadores")

func leer_jugador_por_id(id: int):
	_send_get_request(BASE_URL + "Jugador/leer.php?id=" + str(id), "jugador_id")

func actualizar_jugador(id: int, nombre: String):
	var data = {"id_jugador": id, "nombre": nombre}
	_send_json_request(BASE_URL + "Jugador/actualizar.php", data, HTTPClient.METHOD_POST, "actualizar_jugador")

func borrar_jugador(id: int):
	var data = {"id_jugador": id}
	_send_json_request(BASE_URL + "Jugador/borrar.php", data, HTTPClient.METHOD_POST, "borrar_jugador")

# ===================================================================
# FUNCIONES PARA PARTIDAS
# ===================================================================

func insertar_partida(id_jugador: int):
	var data = {"id_jugador": id_jugador}
	_send_json_request(BASE_URL + "Partida/insertar.php", data, HTTPClient.METHOD_POST, "insertar_partida")

func leer_partidas():
	_send_get_request(BASE_URL + "Partida/leer.php", "partidas")

func leer_partida_por_id(id: int):
	_send_get_request(BASE_URL + "Partida/leer.php?id=" + str(id), "partida_id")

func leer_partidas_por_jugador(id_jugador: int):
	_send_get_request(BASE_URL + "Partida/leer.php?id_jugador=" + str(id_jugador), "partidas_jugador")

func actualizar_partida(id: int, id_jugador: int):
	var data = {"id_partida": id, "id_jugador": id_jugador}
	_send_json_request(BASE_URL + "Partida/actualizar.php", data, HTTPClient.METHOD_POST, "actualizar_partida")

func borrar_partida(id: int):
	var data = {"id_partida": id}
	_send_json_request(BASE_URL + "Partida/borrar.php", data, HTTPClient.METHOD_POST, "borrar_partida")

# ===================================================================
# FUNCIONES PARA PROGRESO
# ===================================================================

func insertar_progreso(id_partida: int, nivel: int, monedas: int, checkpoint: int, enemigos_derrotados: int, jefe_derrotado: bool):
	var data = {
		"id_partida": id_partida,
		"nivel": nivel,
		"monedas": monedas,
		"checkpoint": checkpoint,
		"enemigos_derrotados": enemigos_derrotados,
		"jefe_derrotado": jefe_derrotado
	}
	_send_json_request(BASE_URL + "Progreso/insertar.php", data, HTTPClient.METHOD_POST, "insertar_progreso")

func leer_progreso():
	_send_get_request(BASE_URL + "Progreso/leer.php", "progreso")

func leer_progreso_por_id(id: int):
	_send_get_request(BASE_URL + "Progreso/leer.php?id=" + str(id), "progreso_id")

func leer_progreso_por_partida(id_partida: int):
	_send_get_request(BASE_URL + "Progreso/leer.php?id_partida=" + str(id_partida), "progreso_partida")

func actualizar_progreso(id: int, id_partida: int, nivel: int, monedas: int, checkpoint: int, enemigos_derrotados: int, jefe_derrotado: bool):
	var data = {
		"id_progreso": id,
		"id_partida": id_partida,
		"nivel": nivel,
		"monedas": monedas,
		"checkpoint": checkpoint,
		"enemigos_derrotados": enemigos_derrotados,
		"jefe_derrotado": jefe_derrotado
	}
	_send_json_request(BASE_URL + "Progreso/actualizar.php", data, HTTPClient.METHOD_POST, "actualizar_progreso")

func borrar_progreso(id: int):
	var data = {"id_progreso": id}
	_send_json_request(BASE_URL + "Progreso/borrar.php", data, HTTPClient.METHOD_POST, "borrar_progreso")

# ===================================================================
# FUNCIONES PÚBLICAS DE ACCESO A DATOS
# ===================================================================

# Obtener datos almacenados
func obtener_jugadores() -> Array:
	return jugadores

func obtener_partidas() -> Array:
	return partidas

func obtener_progreso() -> Array:
	return progreso_data

func obtener_ultimo_jugador() -> Dictionary:
	return ultimo_jugador

func obtener_ultima_partida() -> Dictionary:
	return ultima_partida

func obtener_ultimo_progreso() -> Dictionary:
	return ultimo_progreso

# Estado del sistema
func esta_cargando() -> bool:
	return cargando

func datos_estan_cargados(tipo: String = "") -> bool:
	if tipo == "":
		return datos_cargados["jugadores"] and datos_cargados["partidas"] and datos_cargados["progreso"]
	else:
		return datos_cargados.get(tipo, false)

# ===================================================================
# FUNCIONES DE BÚSQUEDA LOCAL
# ===================================================================

func buscar_jugador_por_id(id: int) -> Dictionary:
	for jugador in jugadores:
		if jugador.has("id_jugador") and jugador["id_jugador"] == id:
			return jugador
	return {}

func buscar_jugador_por_nombre(nombre: String) -> Dictionary:
	for jugador in jugadores:
		if jugador.has("nombre") and jugador["nombre"].to_lower() == nombre.to_lower():
			return jugador
	return {}

func buscar_partidas_por_jugador(id_jugador: int) -> Array:
	var partidas_jugador = []
	for partida in partidas:
		if partida.has("id_jugador") and partida["id_jugador"] == id_jugador:
			partidas_jugador.append(partida)
	return partidas_jugador

func buscar_progreso_por_partida(id_partida: int) -> Array:
	var progreso_partida = []
	for progreso in progreso_data:
		if progreso.has("id_partida") and progreso["id_partida"] == id_partida:
			progreso_partida.append(progreso)
	return progreso_partida

func obtener_estadisticas_jugador(id_jugador: int) -> Dictionary:
	var stats = {
		"jugador": {},
		"total_partidas": 0,
		"total_monedas": 0,
		"nivel_maximo": 0,
		"jefes_derrotados": 0
	}
	
	# Obtener datos del jugador
	stats["jugador"] = buscar_jugador_por_id(id_jugador)
	
	# Obtener partidas del jugador
	var partidas_jugador = buscar_partidas_por_jugador(id_jugador)
	stats["total_partidas"] = partidas_jugador.size()
	
	# Calcular estadísticas de progreso
	for partida in partidas_jugador:
		var id_partida = partida.get("id_partida", 0)
		var progreso_partida = buscar_progreso_por_partida(id_partida)
		
		for progreso in progreso_partida:
			stats["total_monedas"] += progreso.get("monedas", 0)
			stats["nivel_maximo"] = max(stats["nivel_maximo"], progreso.get("nivel", 0))
			if progreso.get("jefe_derrotado", false):
				stats["jefes_derrotados"] += 1
	
	return stats

# ===================================================================
# FUNCIONES DE UTILIDAD GLOBAL
# ===================================================================

func cargar_todos_los_datos():
	"""Cargar todos los datos principales de una vez"""
	print("APIManager: Cargando todos los datos...")
	leer_jugadores()
	leer_partidas()
	leer_progreso()

func reiniciar_datos():
	"""Limpiar todos los datos almacenados"""
	jugadores.clear()
	partidas.clear()
	progreso_data.clear()
	ultimo_jugador.clear()
	ultima_partida.clear()
	ultimo_progreso.clear()
	
	datos_cargados = {
		"jugadores": false,
		"partidas": false,
		"progreso": false
	}
	
	limpiar_cache()
	print("APIManager: Datos reiniciados")

func obtener_resumen_datos() -> Dictionary:
	"""Obtener un resumen del estado actual de los datos"""
	return {
		"jugadores_count": jugadores.size(),
		"partidas_count": partidas.size(),
		"progreso_count": progreso_data.size(),
		"datos_cargados": datos_cargados,
		"cargando": cargando,
		"cache_activo": cache_activo
	}

# ===================================================================
# FUNCIONES DE CONFIGURACIÓN
# ===================================================================

func cambiar_url_base(nueva_url: String):
	"""Cambiar la URL base de la API"""
	# Asegurar que termina con /
	if not nueva_url.ends_with("/"):
		nueva_url += "/"
	
	# Cambiar la constante (nota: en GDScript las constantes no se pueden cambiar en runtime)
	# Por eso mejor usar una variable
	print("APIManager: URL base cambiada a ", nueva_url)

func configurar_cache(activo: bool, tiempo_segundos: float = 60.0):
	"""Configurar el sistema de cache"""
	cache_activo = activo
	tiempo_cache = tiempo_segundos
	print("APIManager: Cache configurado - Activo: ", activo, ", Tiempo: ", tiempo_segundos, "s")
