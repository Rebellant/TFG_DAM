extends CharacterBody2D

class_name Player #CREAMOS EL OBJETO PLAYER
signal died # Señal que indica la muerte
@export var attacking = false
const SPEED = 250
const JUMP_VELOCITY = -350
@export var can_die := true  # Variable de control

var can_take_damage = true


func _ready():
	GameManager.player_health = GameManager.player_max_health
	GameManager.health_changed.emit()
	GameManager.player = self

func _process(delta):
	if Input.is_action_just_pressed("atacar"):
		attack()

func attack():
	var overlaping_objects =$AttackArea.get_overlapping_areas()
	for area in overlaping_objects:
		if area.get_parent().is_in_group("can_die_enemy"):
			area.get_parent().die()
	
	attacking = true
	$AnimatedSprite2D.play("attack") 
	await $AnimatedSprite2D.animation_finished
	attacking = false

func take_damage(damage_amount : int):
	if can_take_damage:
		$AnimatedSprite2D.play("damage")	
		GameManager.player_health -= damage_amount
		GameManager.health_changed.emit()
		if GameManager.player_health <= 0:
			die()
	

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true
	
# Función para manejar la muerte del jugado
func die():
	if not can_die:
		return
	can_die = false
	$AnimatedSprite2D.play("death")
	 # Esperar el tiempo de la animación de muerte antes de continuar
	await $AnimatedSprite2D.animation_finished
	died.emit() # Emitir la señal de muerte
#	get_tree().reload_current_scene() # Recargar la escena para reiniciar el juego
	GameManager.respawn_player()
	$AnimatedSprite2D.play("default")
var was_in_air = false  # Variable para detectar si antes estaba en el aire


func _physics_process(delta):
	if GameManager.is_dialogue_active:
		return

	if !can_die:
		return

	velocity += get_gravity() * delta
	# Detectar si antes estaba en el aire
	if !attacking: #SOLO PODRÁ ATACAR SI EL PERSONAJE ESTÁ QUIETO
		var is_now_on_floor = is_on_floor()

		# Agregar gravedad
		if not is_now_on_floor and not attacking:
			
			if velocity.y < 0:  # Si está subiendo
				$AnimatedSprite2D.play("jump")
				
			else:  # Si está cayendo
				$AnimatedSprite2D.play("fall")
				attacking = false
		else:
			# Si antes estaba en el aire y ahora aterrizó, reproducir animación de default
			if was_in_air:
				$AnimatedSprite2D.play("default")
		
		# Detectar salto
		if Input.is_action_just_pressed("ia_up") and is_now_on_floor:
			velocity.y = JUMP_VELOCITY

		# Movimiento horizontal
		

		if Input.is_action_pressed("ia_left"):
			$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * -1
			$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
		if  Input.is_action_pressed("ia_right"):
			$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)
			$AttackArea.scale.x = abs($AttackArea.scale.x)
			
		var direction := Input.get_axis("ia_left", "ia_right")
		if direction:
			velocity.x = direction * SPEED
			if is_now_on_floor:  # Si está en el suelo, correr
				$AnimatedSprite2D.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_now_on_floor:  # Solo cambiar a idle si está en el suelo
				$AnimatedSprite2D.play("default")

		# Guardar el estado anterior
		was_in_air = not is_now_on_floor  
		
		if Input.is_action_just_pressed("atacar") and is_on_floor():
			attack()
	
		move_and_slide()
	else:
		$AnimatedSprite2D.play("attack")
		
		await($AnimatedSprite2D.animation_finished) #ESPERA A QUE LA ANIMACION DE ATAQUE TERMINE PARA PONER LA VARIABLE ATACAR EN FALSO
		attacking = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(attacking):
		print("Attack!")
