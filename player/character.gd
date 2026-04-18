extends CharacterBody2D
var health =200
var cam
var bg

func _ready() -> void:
	var current_scene = get_tree().current_scene
	cam = get_tree().current_scene.get_node("cam")
	bg = get_tree().current_scene.get_node("bg")
	print(cam)
	if !cam:
		print("sad")
	
func take_damage():
	health -=10
	print("OWW")
	if cam:
		cam.apply_shake()
	if bg:
		var tween = create_tween()
		tween.tween_property(bg, "modulate", Color(1.0,0.85,0.85,0.9),0.2)
		tween.tween_property(bg, "modulate", Color(1.0,1.0,1.0,1.0),0.15)
	

	
	
	
	
	


func _on_miss_detector_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
