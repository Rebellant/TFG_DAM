extends Node

signal partidas_recibidas(partidas)
signal progreso_recibido(progresos)

var http := HTTPRequest.new()
var _esperando := ""  # Para saber si estamos esperando "partidas" o "progreso"

func _ready():
	add_child(http)

# 🔹 Leer partidas reales desde PHP
func leer_partidas_por_jugador(id_jugador: int):
	var url = "http://localhost/API_Godot/crud/Partida/leer.php?id_jugador=%d" % id_jugador
	_esperando = "partidas"
	http.request_completed.connect(_on_request_completed, CONNECT_ONE_SHOT)
	http.request(url)

# 🔹 Leer progreso real desde PHP
func leer_progreso_por_partida(id_partida: int):
	var url = "http://localhost/API_Godot/crud/Progreso_partida/leer.php?id_partida=%d" % id_partida
	_esperando = "progreso"
	http.request_completed.connect(_on_request_completed, CONNECT_ONE_SHOT)
	http.request(url)

# 🔹 Procesador genérico de respuestas
func _on_request_completed(result, code, headers, body):
	if code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())

		# ✅ Si es una lista
		if typeof(json) == TYPE_ARRAY:
			if _esperando == "partidas":
				emit_signal("partidas_recibidas", json)
			elif _esperando == "progreso":
				emit_signal("progreso_recibido", json)

		# ✅ Si es solo un objeto (diccionario)
		elif typeof(json) == TYPE_DICTIONARY:
			if _esperando == "partidas":
				emit_signal("partidas_recibidas", [json])  # Lo metemos en un array
			elif _esperando == "progreso":
				emit_signal("progreso_recibido", [json])
		else:
			print("La respuesta no fue válida. JSON:", json)
	else:
		print("Error HTTP:", code)
