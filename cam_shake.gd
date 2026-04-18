extends Camera2D

@export var randstr: float = 30.0
@export var fade: float = 5.0
 
var rng = RandomNumberGenerator.new()

var shake_str: float = 0.0

func _ready() -> void:
	pass 

func apply_shake():
	shake_str = randstr
	print("shaking")

func _process(delta: float) -> void:
	
	if shake_str > 0:
		shake_str = lerpf(shake_str,0,fade*delta)
	offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))
