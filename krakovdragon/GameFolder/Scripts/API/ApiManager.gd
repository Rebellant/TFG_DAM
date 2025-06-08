extends Node

# URL base de tu API
const BASE_URL = "http://localhost/API_Godot/crud/"

# --- ENVIAR SOLICITUD JSON ---
func _send_json_request(url: String, data: Dictionary, method: HTTPClient.Method):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json"
	]
	
	var json_string = JSON.stringify(data)
	
	http_request.request_completed.connect(func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		var response_text = body.get_string_from_utf8()
		var parsed_data = null
		
		if response_text != "":
			var json = JSON.new()
			var parse_result = json.parse(response_text)
			if parse_result == OK:
				parsed_data = json.data
			else:
				parsed_data = response_text
		
		# Imprimir resultado por consola
		print("=== RESPUESTA API ===")
		print("Código: ", response_code)
		if parsed_data:
			print("Datos: ", parsed_data)
		else:
			print("Respuesta: ", response_text)
		print("==================")
		
		http_request.queue_free()
	)
	
	http_request.request(url, headers, method, json_string)

# --- ENVIAR SOLICITUD GET ---
func _send_get_request(url: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var headers = [
		"Accept: application/json"
	]
	
	http_request.request_completed.connect(func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
		var response_text = body.get_string_from_utf8()
		var parsed_data = null
		
		if response_text != "":
			var json = JSON.new()
			var parse_result = json.parse(response_text)
			if parse_result == OK:
				parsed_data = json.data
			else:
				parsed_data = response_text
		
		# Imprimir resultado por consola
		print("=== RESPUESTA API ===")
		print("Código: ", response_code)
		if parsed_data:
			print("Datos: ", parsed_data)
		else:
			print("Respuesta: ", response_text)
		print("==================")
		
		http_request.queue_free()
	)
	
	http_request.request(url, headers, HTTPClient.METHOD_GET)

# ===========================================
# FUNCIONES PARA JUGADORES
# ===========================================

# Crear jugador
func insertar_jugador(nombre: String):
	var data = {"nombre": nombre}
	_send_json_request(BASE_URL + "Jugador/insertar.php", data, HTTPClient.METHOD_POST)

# Leer TODOS los jugadores
func leer_jugadores():
	_send_get_request(BASE_URL + "Jugador/leer.php")

# Leer jugador por ID
func leer_jugador_por_id(id: int):
	_send_get_request(BASE_URL + "Jugador/leer.php?id=" + str(id))

# Actualizar jugador
func actualizar_jugador(id: int, nombre: String):
	var data = {"id_jugador": id, "nombre": nombre}
	_send_json_request(BASE_URL + "Jugador/actualizar.php", data, HTTPClient.METHOD_POST)

# Borrar jugador
func borrar_jugador(id: int):
	var data = {"id_jugador": id}
	_send_json_request(BASE_URL + "Jugador/borrar.php", data, HTTPClient.METHOD_POST)

# ===========================================
# FUNCIONES PARA PARTIDAS
# ===========================================

# Crear partida
func insertar_partida(id_jugador: int):
	var data = {"id_jugador": id_jugador}
	_send_json_request(BASE_URL + "Partida/insertar.php", data, HTTPClient.METHOD_POST)

# Leer TODAS las partidas
func leer_partidas():
	_send_get_request(BASE_URL + "Partida/leer.php")

# Leer partida por ID
func leer_partida_por_id(id: int):
	_send_get_request(BASE_URL + "Partida/leer.php?id=" + str(id))

# Leer partidas de un jugador específico
func leer_partidas_por_jugador(id_jugador: int):
	_send_get_request(BASE_URL + "Partida/leer.php?id_jugador=" + str(id_jugador))

# Actualizar partida
func actualizar_partida(id: int, id_jugador: int):
	var data = {"id_partida": id, "id_jugador": id_jugador}
	_send_json_request(BASE_URL + "Partida/actualizar.php", data, HTTPClient.METHOD_POST)

# Borrar partida
func borrar_partida(id: int):
	var data = {"id_partida": id}
	_send_json_request(BASE_URL + "Partida/borrar.php", data, HTTPClient.METHOD_POST)

# ===========================================
# FUNCIONES PARA PROGRESO
# ===========================================

# Guardar progreso
func insertar_progreso(id_partida: int, nivel: int, monedas: int, checkpoint: int, enemigos_derrotados: int, jefe_derrotado: bool):
	var data = {
		"id_partida": id_partida,
		"nivel": nivel,
		"monedas": monedas,
		"checkpoint": checkpoint,
		"enemigos_derrotados": enemigos_derrotados,
		"jefe_derrotado": jefe_derrotado
	}
	_send_json_request(BASE_URL + "Progreso/insertar.php", data, HTTPClient.METHOD_POST)

# Leer TODO el progreso
func leer_progreso():
	_send_get_request(BASE_URL + "Progreso/leer.php")

# Leer progreso por ID
func leer_progreso_por_id(id: int):
	_send_get_request(BASE_URL + "Progreso/leer.php?id=" + str(id))

# Leer progreso por partida
func leer_progreso_por_partida(id_partida: int):
	_send_get_request(BASE_URL + "Progreso/leer.php?id_partida=" + str(id_partida))

# Actualizar progreso
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
	_send_json_request(BASE_URL + "Progreso/actualizar.php", data, HTTPClient.METHOD_POST)

# Borrar progreso
func borrar_progreso(id: int):
	var data = {"id_progreso": id}
	_send_json_request(BASE_URL + "Progreso/borrar.php", data, HTTPClient.METHOD_POST)
