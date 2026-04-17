class_name NodeStateMachine
extends Node

@export var initial_node_state: NodeState
@export var character: CharacterBody2D
@export var anim_player: AnimationPlayer

var node_states: Dictionary = {}
var current_node_state: NodeState
var current_node_state_name: String
var timing_is_right = false
const up_gravity = 220
const down_gravity = 420

const inputs = ["wave", "jump", "loop", "cross" ]

func _ready() -> void:
	
	for child in get_children():
		if child is NodeState:
			node_states[child.name]= child
	
	if initial_node_state:
		initial_node_state.enter()
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name
	anim_player.play(current_node_state_name)


func _process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_process(delta)



func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_physics_process(delta)
	
	
	

	
	character.move_and_slide()
	


func transition_to(node_state_name):
	if current_node_state and node_state_name == current_node_state.name:
		return

	var new_node_state = node_states.get(node_state_name)
	if !new_node_state:
		return
	var obst_name =  global.current_obst.to_lower()
	var state_name_l = node_state_name.to_lower()
	var will_play = false

	if obst_name.find(state_name_l) != -1 and timing_is_right:
		will_play = true
	elif state_name_l == "walk":
		will_play = true
	

	if not will_play:
		return


	if current_node_state:
		current_node_state.exit()

	new_node_state.enter()
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name
	anim_player.play(current_node_state_name)
	global.character_state = current_node_state_name






func _on_timing_detector_area_entered(area: Area2D) -> void:
	var obst_node: Node = area
	var obst_type = ""
	if area.has_meta("obstacle_type"):
		obst_type = str(area.get_meta("obstacle_type"))
	else:
		if not obst_node.is_in_group("obstacles") and obst_node.get_parent() and obst_node.get_parent().is_in_group("obstacles"):
			obst_node = obst_node.get_parent()
		if obst_node.is_in_group("obstacles"):
			obst_type = obst_node.name
	if obst_type != "":
		timing_is_right = true
		global.current_obst = obst_type


func _on_timing_detector_area_exited(area: Area2D) -> void:
	timing_is_right=false
	var obst_type = ""
	if area.has_meta("obstacle_type"):
		obst_type = str(area.get_meta("obstacle_type"))
	else:
		var obst_node: Node = area
		if not obst_node.is_in_group("obstacles") and obst_node.get_parent() and obst_node.get_parent().is_in_group("obstacles"):
			obst_node = obst_node.get_parent()
		if obst_node.is_in_group("obstacles"):
			obst_type = obst_node.name
	if obst_type != "" and global.current_obst == obst_type:
		global.current_obst = ""


func _on_miss_detector_area_entered(area: Area2D) -> void:
	if current_node_state_name == "walk":
		character.take_damage()


func _on_miss_detector_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
