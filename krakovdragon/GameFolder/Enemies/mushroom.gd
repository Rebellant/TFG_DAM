extends CharacterBody2D


var speed = -60.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = false
var player_in_area = false
var health = 200
var max_health = 200

func _ready():
	$AnimatedSprite2D.play("run")


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !$RayCast2D.is_colliding() && is_on_floor() || $RayCast2D2.is_colliding(): 
		flip()
	
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * - 1



func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		_ready()
		area.get_parent().take_damage(40)

func die():
	player_in_area = false
	$Hitbox.monitoring = false
	$AttackArea.monitoring = false
	speed = 0
	$AnimatedSprite2D.play("die")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func take_damage(damage_amount:int):
	health -= damage_amount
	$AnimatedSprite2D.play("hit")
	get_node("HealthBar").update_healthbar(health,max_health)
	if health <= 0:
		GameManager.enemies_killed +=1
		die()

func _on_attack_area_area_exited(area:):
	player_in_area = false

func _on_attack_area_area_entered(area):
	player_in_area = true
	if area.get_parent() is Player:
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished
		if player_in_area == true:
			area.get_parent().take_damage(40)
			_ready()
		else:
			_ready()
