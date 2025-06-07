extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 20.0
var facing_left = false
const dialogue = preload("res://GameFolder/Dialogues/dialogue_npc_lvl2.dialogue")




@onready var anim_player = $AnimatedSprite2D
var interactuable:bool = false

func _ready():
	GameManager.level_portal_active = false
	anim_player.play("idle")
	$AnimationPlayer.play("no_interactuar")
	$Sprite2D.hide()
	DialogueManager.dialogue_started.connect(on_dialogue_started)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)

func _on_hit_box_area_entered(area):
	if area.get_parent() is Player :
		$AnimationPlayer.play("Interactuar")
		$Sprite2D.show()
		interactuable = true


func _on_hit_box_area_exited(area):
	$AnimationPlayer.play("no_interactuar")
	$Sprite2D.hide()
	interactuable = false

func _process(delta):
	if interactuable and Input.is_action_just_pressed("Interactuar") and not GameManager.is_dialogue_active:
		DialogueManager.show_dialogue_balloon(dialogue)
	disappear()

func on_dialogue_started(dialogue):
	GameManager.is_dialogue_active = true

func on_dialogue_ended(dialogue):
	
	await get_tree().create_timer(0.2).timeout
	GameManager.is_dialogue_active = false

func disappear():
	if GameManager.dissapear_npc2 == true:
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()
