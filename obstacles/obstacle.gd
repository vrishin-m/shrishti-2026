extends Node2D
var speed=7.0
var character: CharacterBody2D
var tip: RichTextLabel
var distance
func _ready() -> void:
	add_to_group("obstacles")
	character = get_parent().get_node("character")
	tip =  get_parent().get_node("tip")
	if !character:
		pass
	global.current_obst = self.name
	print("MAX VERSTAPPEN", self.name)
	print(global.current_obst)
	var name = self.name.to_lower()
	
	if name == "jump":
		tip.text= "Press W or Up arrow!"
	elif name == "cross":
		tip.text= "Press S or Down arrow!"
	elif name == "loop":
		tip.text= "Press A or Left arrow!"
	elif name == "wave":
		tip.text= "Press D or Right arrow!"
	elif name == "jumpcross":
		tip.text= "Press W+S or Up+Down arrow!"
	elif name == "jumploop":
		tip.text= "Press W+A or Up+Left arrow!"
	elif name == "jumpwave":
		tip.text= "Press W+D or Up+Right arrow!"
	elif name == "crosswave":
		tip.text= "Press S+D or Down+Right arrow!"
	elif name == "crossloop":
		tip.text= "Press S+A or Down+Left arrow!"
	elif name == "waveloop":
		tip.text= "Press A+D or Left+Right arrow!"
	
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(300,300)
	var area = Area2D.new()
	area.add_to_group("obstacles")
	area.add_child(collision_shape)
	self.add_child(area)

func _process(delta: float) -> void:
	position.x -=speed
	
	if position.x <=-20:
		print("udhaaaay")
		tip.text =""
		queue_free()
	
	
	
		
	
