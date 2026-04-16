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
	pass
	




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	node_state_machine.transition_to("walk")
	requested_state="walk"
			




func _input(event: InputEvent) -> void:
	if gamemode == "singleplayer":
		if can_two_states:
			print("srjgjta")
			for i in node_state_machine.inputs:
				if event.is_action_pressed(i+'1') or event.is_action_pressed(i+'2'):
					print("HERE")
					print(i+requested_state)
					if (i+requested_state) in node_state_machine.node_states:
						print("NANANAN")
						node_state_machine.transition_to(i+requested_state)
					else:
						node_state_machine.transition_to(requested_state+i)
					can_two_states=false
					
		
		
		
		elif node_state_machine.current_node_state_name  == "walk":
			for i in node_state_machine.inputs:
					if event.is_action_pressed(i+'1') or event.is_action_pressed(i+'2'):
						print("the code has arrived here, my lord")
						requested_state = i
						$Timer.start()
						can_two_states = true
						
			
					
		
	else:
		if node_state_machine.current_node_state_name  == "walk":
			for i in node_state_machine.node_states:
				if i !="walk":
					if event.is_action_pressed(i+'1') or event.is_action_pressed(i+'2'):
						node_state_machine.transition_to(i)
	
		
		
			



		

		
		
		


func _on_timer_timeout() -> void:
	if can_two_states:
		can_two_states= false
		node_state_machine.transition_to(requested_state)
	
