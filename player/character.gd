extends CharacterBody2D
var health =200

func ready():
	var current_scene = get_tree().current_scene
	
func take_damage():
	health -=10
	print("OWW")
	
	
	
	


func _on_miss_detector_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
