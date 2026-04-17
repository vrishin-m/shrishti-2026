extends Node2D
var speed=7.0
var character: CharacterBody2D
var tip: RichTextLabel
var distance
var obstacle_type: String = ""
func _ready() -> void:
	add_to_group("obstacles")
	character = get_parent().get_node("character")
	tip =  get_parent().get_node("tip")
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


	if obstacle_type == "jump":
		tip.text = "Press W or Up arrow!"
	elif obstacle_type == "cross":
		tip.text = "Press S or Down arrow!"
	elif obstacle_type == "loop":
		tip.text = "Press A or Left arrow!"
	elif obstacle_type == "wave":
		tip.text = "Press D or Right arrow!"
	elif obstacle_type == "jumpcross":
		tip.text = "Press W+S or Up+Down arrow!"
	elif obstacle_type == "jumploop":
		tip.text = "Press W+A or Up+Left arrow!"
	elif obstacle_type == "jumpwave":
		tip.text = "Press W+D or Up+Right arrow!"
	elif obstacle_type == "crosswave":
		tip.text = "Press S+D or Down+Right arrow!"
	elif obstacle_type == "crossloop":
		tip.text = "Press S+A or Down+Left arrow!"
	elif obstacle_type == "waveloop":
		tip.text = "Press A+D or Left+Right arrow!"
	else:
		tip.text = ""
	
	

	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(200,300)
	var area = Area2D.new()
	area.name = "%s_area" % obstacle_type
	area.add_to_group("obstacles")
	area.set_meta("obstacle_type", obstacle_type)
	area.add_child(collision_shape)
	self.add_child(area)

func _process(delta: float) -> void:
	position.x -=speed
	
	if position.x <= -20:
		queue_free()

func free() -> void:
	tip.text = ""
	
		
	
