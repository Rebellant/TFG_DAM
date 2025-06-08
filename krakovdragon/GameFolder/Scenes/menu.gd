extends Control


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GameFolder/Levels/nivel_1.tscn")


func _on_texture_Options_pressed() -> void:
	get_tree().change_scene_to_file("res://GameFolder/Scenes/options.tscn")




func _on_btn_continuar_pressed() -> void:
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

func _on_btn_exit_pressed() -> void:
	get_tree().quit() #SALE DEL JUEGO
