extends NodeState

@export var character: CharacterBody2D
@export var anim_player: AnimationPlayer

const jump_speed = 200



func on_process(_delta):
	pass


func on_physics_process(delta):
	pass
	


func enter():
	character.velocity.y -= jump_speed

func exit():  
	pass
