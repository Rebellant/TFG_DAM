extends Area2D

@onready var player: Player = $"../Player"  # Asegúrate de que la ruta es correcta

func _ready():
	# Verificar si la señal ya está conectada
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:  # Verificar si el objeto que entra es un jugador
		if player.can_die:  # Comprobar si el jugador puede morir
			player.die()  # Llamar a la función de muerte del jugador
