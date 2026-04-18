'''this is the script that "controls" the player. whenever the player presses an action, 
they go to the corresponding state. 
once the animation of that state is done playing, they go back to the walk state 
(which is kind of the default state). to keep things simple, the player can only transition 
to other states from the walk state. 
so there is only one animation per state '''



extends Node

@export var node_state_machine: NodeStateMachine

@export var player: CharacterBody2D
@export var anim_player: AnimationPlayer
var gamemode = "singleplayer"
var can_two_states = false
var requested_state = "walk"

func _ready() -> void:
	set_process_input(true)
	set_process_unhandled_input(true)
	print("[SMC] ready - input processing enabled (handled+unhandled)")
	




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("[SMC] animation finished:", anim_name)
	node_state_machine.transition_to("walk")
	requested_state="walk"
			




func _input(event: InputEvent) -> void:
	if gamemode == "singleplayer":
		if can_two_states:
			var modified_list = node_state_machine.inputs.duplicate()
			modified_list.erase(requested_state)
			for i in modified_list:
				if Input.is_action_pressed(i+'1') or Input.is_action_pressed(i+'2'):
					var candidate = i + requested_state
					print(candidate, "candidate")
					if candidate in node_state_machine.node_states:
						node_state_machine.transition_to(candidate)
					elif (requested_state + i) in node_state_machine.node_states:
						var candidate2 = requested_state + i
						node_state_machine.transition_to(candidate2)
					else:
						node_state_machine.transition_to(requested_state)
					can_two_states=false

		elif node_state_machine.current_node_state_name  == "walk":

			for i in node_state_machine.inputs:
				if Input.is_action_just_pressed(i+'1') or Input.is_action_just_pressed(i+'2'):
					requested_state = i
					if $Timer.is_stopped():
						$Timer.start()
						can_two_states = true
						
			
					
		
	else:
		if node_state_machine.current_node_state_name  == "walk":
			for i in node_state_machine.node_states:
				if i != "walk":
					if Input.is_action_just_pressed(i+'1') or Input.is_action_just_pressed(i+'2'):
						node_state_machine.transition_to(i)
	
		
		
			



		

		
		
		


func _on_timer_timeout() -> void:
	if can_two_states:
		can_two_states= false
		node_state_machine.transition_to(requested_state)
	requested_state="walk"
