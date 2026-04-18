extends Node2D

var timestamps: Dictionary
var times
var obstacles
var chosen_obst
var run_time=0.0
var time_adjustment=1.8

class obstacle_class extends Node:
	var scene
	func spawn_obstacle():
		var obst_scene = self.scene
		var instance = obst_scene.instantiate()
		instance.global_position = Vector2(1200,400)
		instance.scale = Vector2(1.4,1.4)
		var tree = Engine.get_main_loop() as SceneTree
		tree.current_scene.add_child(instance)
		
	func _init(s) -> void:
		scene = s


	

var jump = obstacle_class.new(preload("res://obstacles/jump.tscn"))
var cross = obstacle_class.new(preload("res://obstacles/cross.tscn"))
var wave = obstacle_class.new(preload("res://obstacles/wave.tscn"))
var loop = obstacle_class.new(preload("res://obstacles/loop.tscn"))	

var jumpcross = obstacle_class.new(preload("res://obstacles/jumpcross.tscn"))
var jumpwave = obstacle_class.new(preload("res://obstacles/jumpwave.tscn"))
var jumploop = obstacle_class.new(preload("res://obstacles/jumploop.tscn"))
var crosswave = obstacle_class.new(preload("res://obstacles/crosswave.tscn"))	
var crossloop = obstacle_class.new(preload("res://obstacles/crossloop.tscn"))
var waveloop = obstacle_class.new(preload("res://obstacles/waveloop.tscn"))


func read_json(file_path: String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		var data = JSON.parse_string(json_string)
		if data:
			print(data)
			return data
	
	
	
	

func _ready() -> void:
	timestamps = global.json
	times = timestamps.keys()
	obstacles = timestamps.values()
	
	var stream = AudioStreamMP3.new()
	stream.data = global.song 

	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.play()
	$up.modulate.a =0.5
	$down.modulate.a =0.5
	$left.modulate.a =0.5
	$right.modulate.a =0.5

func _physics_process(delta: float) -> void:
	run_time +=delta
	if times:
		if float(times[0])- time_adjustment- run_time <=0.01:
			print("NUTJAUJNGJBGAGR")
			if len(obstacles[0]) >1:
				chosen_obst = Array(obstacles[0].split(""))
				chosen_obst.shuffle()
				chosen_obst= "".join(chosen_obst.slice(0,2))
				if chosen_obst in "MBM":
					jumpcross.spawn_obstacle()
				elif chosen_obst in "MSM":
					crosswave.spawn_obstacle()
				elif chosen_obst in "MTM":
					crossloop.spawn_obstacle()
				elif chosen_obst in "BSB":
					jumpwave.spawn_obstacle()
				elif chosen_obst in "BTB":
					jumploop.spawn_obstacle()
				else:
					waveloop.spawn_obstacle()
					
			else:
				chosen_obst = obstacles[0]
				if chosen_obst =="B":
					jump.spawn_obstacle()
				elif chosen_obst == "M":
					cross.spawn_obstacle()
				elif chosen_obst == "S":
					wave.spawn_obstacle()
				elif chosen_obst== "T":
					loop.spawn_obstacle()
			print("udhay", chosen_obst)		
			times.remove_at(0)
			obstacles.remove_at(0)
		
			
			
		
		
	
	
