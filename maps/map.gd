extends StaticBody2D

@onready var poly_node = $CollisionPolygon2D


var width = 1200       
var resolution = 10  
var amplitude = 30     
var frequency = 0.012  
var speed = 5.0        
var time = 0.0        

func _physics_process(delta):
	time += delta
	update_wave_collision()

func update_wave_collision():
	var points = PackedVector2Array()
	for x in range(0, width, resolution):
		var y = sin(x * frequency + time * speed) * amplitude
		points.append(Vector2(x, y))

	points.append(Vector2(width, 200))
	points.append(Vector2(0, 200))     
	poly_node.polygon = points

func _process(_delta):
	queue_redraw() 

func _draw():
	var poly = poly_node.polygon
	draw_colored_polygon(poly, Color(0.2, 0.5, 1.0, 0.8))
