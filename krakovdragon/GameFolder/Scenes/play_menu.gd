extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_new_game_pressed():
	get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")


func _on_btn_continue_pressed():
	var level = 1 #LECTOR DEL JSON ESTE ES EL VALOR DEL NIVEL
	match level:
		1:
			get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")
		2:
			get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_2.tscn")
		3:
			get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_3.tscn")
		_:
			get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")


func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://GameFolder/Scenes/menu.tscn")
