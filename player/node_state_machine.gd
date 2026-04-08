class_name NodeStateMachine
extends Node

@export var initial_node_state: NodeState
@export var character: CharacterBody2D
@export var anim_player: AnimationPlayer

var node_states: Dictionary = {}
var current_node_state: NodeState
var current_node_state_name: String

const up_gravity = 220
const down_gravity = 420



func _ready() -> void:
	
	for child in get_children():
		if child is NodeState:
			node_states[child.name]= child
	
	if initial_node_state:
		initial_node_state.enter()
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name
		print(current_node_state_name)



func _process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_process(delta)



func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_physics_process(delta)
	
	
	if !character.is_on_floor():
		if character.velocity.y <0:
			character.velocity.y += up_gravity*delta
		else:
			character.velocity.y += down_gravity*delta

	
	character.move_and_slide()
	


func transition_to(node_state_name):
	if node_state_name == current_node_state.name:
		return
	
	var new_node_state = node_states.get(node_state_name)
	if !new_node_state:
		return
	
	if current_node_state:
		current_node_state.exit()
	
	new_node_state.enter()
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name
	anim_player.play(current_node_state_name)
	print(current_node_state_name)
