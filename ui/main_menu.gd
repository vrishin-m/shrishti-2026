extends Control
var json

@onready var http_request = $HTTPRequest
@onready var mp3_request = $mp3_file_request
func _ready() -> void:
	$loading.z_index =-4
	$loading_wheel.z_index =-4

func _on_button_button_down() -> void:
	$loading.z_index=2
	$loading_wheel.z_index =3
	$AnimationPlayer.play("new_animation")
	var url = $LineEdit.text
	url = url.split("=")[-1]
	if url:
		var headers = ["Content-Type: application/json"]
		http_request.request("http://127.0.0.1:8000/song/" + url, headers, HTTPClient.METHOD_GET, url)
	else:
		print("enter a valid url")
	


func _on_http_request_request_completed(result: int, response_code: int, headers, body: PackedByteArray) -> void:
	#json = JSON.parse_string(headers.get_string_from_utf8())
	#global.json=json
	#mp3_request.request("http://127.0.0.1:8000/download/file")
	print(headers)
	#for header in headers:
			#var json_string = header.split(":", true, 1)[1].strip_edges()
			#var json_data = JSON.parse_string(json_string)
			#print("Extracted Header Data: ", json_data)
	var json_data = (JSON.parse_string(headers[2].split(":", true, 1)[1]))
	print(json_data)
	global.json = json_data
	global.song = body
	#var stsong = AudioStreamMP3.new()
	#stream.data = body 
#
	#var player = AudioStreamPlayer.new()
	#add_child(player)
	#player.stream = stream
	#player.play()
	#var file_path = "user://download.mp3"
	#var file = FileAccess.open(file_path, FileAccess.WRITE)
	#file.store_buffer(body)
	#file.close()
	
	#var stream = AudioStreamMP3.new()
	#stream.data = body 
#
	#var player = AudioStreamPlayer.new()
	#add_child(player)
	#player.stream = stream
	#player.play()
	get_tree().change_scene_to_file("res://maps/custom_level.tscn")


	


func _on_mp_3_file_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var save_path = "user://song_file.mp3"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_buffer(body)
		file.close()
		print("saved the song")
	#get_tree().change_scene_to_file("res://ui/spilt-screen-mode.tscn")	
	get_tree().change_scene_to_file("res://maps/custom_level.tscn")


func _on_button_2_button_down() -> void:
	get_tree().change_scene_to_file("res://maps/tutorial.tscn")
