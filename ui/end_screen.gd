extends Node2D


func _on_retry_button_down() -> void:
	pass # Replace with function body.


func _on_home_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
