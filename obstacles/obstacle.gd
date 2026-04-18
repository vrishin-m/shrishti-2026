extends Node2D
var speed=7.0
var character: CharacterBody2D
var tip: RichTextLabel
var distance
var obstacle_type: String = ""
var up 
var down 
var right 
var left 
func _ready() -> void:
	add_to_group("obstacles")
	character = get_parent().get_node("character")
	tip = get_parent().get_node("tip")
	
	var up = get_parent().get_node("up")
	var down = get_parent().get_node("down")
	var right = get_parent().get_node("right")
	var left = get_parent().get_node("left")
	#
	#var tip = RichTextLabel.new()
	#tip.position = Vector2(500,500)
	
	
	if !character:
		pass

	
	var raw = ""
	var sprite = get_node_or_null("Sprite2D")
	if sprite and sprite.texture:
		var tex_path = sprite.texture.resource_path
		if tex_path and tex_path != "":
			raw = tex_path.get_file().to_lower()
	if raw == "":
		raw = self.name.to_lower()


	var keywords = []
	var known = ["jump", "cross", "wave", "loop"]
	for k in known:
		if raw.find(k) != -1:
			keywords.append(k)


	var ordered = []
	var priority = ["jump", "cross", "wave", "loop"]
	for p in priority:
		if p in keywords:
			ordered.append(p)

	if ordered.size() == 0:
		obstacle_type = raw
	else:
		var ob = ""
		for s in ordered:
			ob += s
		obstacle_type = ob


	
	
	#add_child(tip)

	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(100,300)
	var area = Area2D.new()
	area.name = "%s_area" % obstacle_type
	area.add_to_group("obstacles")
	area.set_meta("obstacle_type", obstacle_type)
	area.add_child(collision_shape)
	self.add_child(area)
	
	await get_tree().create_timer(0.5).timeout
	if obstacle_type == "jump":
		tip.text = "Press Y or Up arrow!"
		up.modulate.a =1
		down.modulate.a =0.5
		left.modulate.a =0.5
		right.modulate.a =0.5
	elif obstacle_type == "cross":
		tip.text = "Press A or Down arrow!"
		up.modulate.a =0.5
		down.modulate.a =1
		left.modulate.a =0.5
		right.modulate.a =0.5
	elif obstacle_type == "loop":
		tip.text = "Press X or Left arrow!"
		up.modulate.a =0.5
		down.modulate.a =0.5
		left.modulate.a =1
		right.modulate.a =0.5
	elif obstacle_type == "wave":
		tip.text = "Press B or Right arrow!"
		up.modulate.a =0.5
		down.modulate.a =0.5
		left.modulate.a =0.5
		right.modulate.a =1
	elif obstacle_type == "jumpcross":
		tip.text = "Press Y+A or Up+Down arrow!"
		up.modulate.a =1
		down.modulate.a =1
		left.modulate.a =0.5
		right.modulate.a =0.5
	elif obstacle_type == "jumploop":
		tip.text = "Press Y+X or Up+Left arrow!"
		up.modulate.a =1
		down.modulate.a =0.5
		left.modulate.a =1
		right.modulate.a =0.5
	elif obstacle_type == "jumpwave":
		tip.text = "Press Y+B or Up+Right arrow!"
		up.modulate.a =1
		down.modulate.a =0.5
		left.modulate.a =0.5
		right.modulate.a =1
	elif obstacle_type == "crosswave":
		tip.text = "Press A+B or Down+Right arrow!"
		up.modulate.a =0.5
		down.modulate.a =1
		left.modulate.a =0.5
		right.modulate.a =1
	elif obstacle_type == "crossloop":
		tip.text = "Press A+X or Down+Left arrow!"
		up.modulate.a =0.5
		down.modulate.a =1
		left.modulate.a =1
		right.modulate.a =0.5
	elif obstacle_type == "waveloop":
		tip.text = "Press X+B or Left+Right arrow!"
		up.modulate.a =0.5
		down.modulate.a =0.5
		left.modulate.a =1
		right.modulate.a =1
	else:
		tip.text = ""
		up.modulate.a =0.5
		down.modulate.a =0.5
		left.modulate.a =0.5
		right.modulate.a =0.5

func _process(delta: float) -> void:
	position.x -=speed
	
	if position.x <= -30:
		queue_free()

func free() -> void:
	tip.text = ""
	up.modulate.a =0.5
	down.modulate.a =0.5
	left.modulate.a =0.5
	right.modulate.a =0.5
	
		
	
