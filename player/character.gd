extends CharacterBody2D
var health =200

func ready():
	var current_scene = get_tree().current_scene
	
func take_damage():
	health -=10
	
	
	
	
