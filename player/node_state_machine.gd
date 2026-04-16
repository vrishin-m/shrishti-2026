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
	print("[NSM] transition_to:", node_state_name)
	# guard: if already in this state, nothing to do
	if current_node_state and node_state_name == current_node_state.name:
		return

	var new_node_state = node_states.get(node_state_name)
	if !new_node_state:
		print("[NSM] unknown state:", node_state_name)
		return

	# Decide whether the requested state will actually play an animation.
	var obst_name =  global.current_obst.to_lower()
	var state_name_l = node_state_name.to_lower()
	print("[NSM] comparing obstacle:'%s' to state:'%s'" % [obst_name, state_name_l])
	var will_play = false
	# match by substring to handle named areas like 'jump_area' or stable types
	if obst_name.find(state_name_l) != -1 and timing_is_right:
		will_play = true
		print("[NSM] obstacle matches and timing is right -> will play", node_state_name)
	elif state_name_l == "walk":
		will_play = true
		print("[NSM] transitioning to walk -> will play walk")
	else:
		print("[NSM] won't play state (either timing wrong or obstacle mismatch):", node_state_name)

	if not will_play:
		# don't change current state if the animation won't run
		return

	# perform the state change since animation will run
	if current_node_state:
		current_node_state.exit()

	new_node_state.enter()
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name
	anim_player.play(current_node_state_name)
	global.character_state = current_node_state_name
	print("[NSM] current state:", current_node_state_name)





func _on_timing_detector_area_entered(area: Area2D) -> void:
	print("[NSM] area entered:", area)
	var obst_node: Node = area
	var obst_type = ""
	# prefer explicit meta set on the Area2D
	if area.has_meta("obstacle_type"):
		obst_type = str(area.get_meta("obstacle_type"))
	else:
		# If the Area2D itself isn't put in the group, check its parent (the obstacle node)
		if not obst_node.is_in_group("obstacles") and obst_node.get_parent() and obst_node.get_parent().is_in_group("obstacles"):
			obst_node = obst_node.get_parent()
		if obst_node.is_in_group("obstacles"):
			obst_type = obst_node.name
	if obst_type != "":
		timing_is_right = true
		global.current_obst = obst_type
		print("TIMING IS RIGHT - current_obst:", global.current_obst)


func _on_timing_detector_area_exited(area: Area2D) -> void:
	print("[NSM] area exited:", area)
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
		print("cleared current_obst")
