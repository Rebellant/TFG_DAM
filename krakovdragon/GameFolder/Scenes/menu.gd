extends Control


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GameFolder/Scenes/nivel_1.tscn")


func _on_texture_button_exit_pressed() -> void:
	get_tree().quit() #SALE DEL JUEGO


func _on_texture_Options_pressed() -> void:
	get_tree().change_scene_to_file("res://GameFolder/Scenes/options.tscn")
