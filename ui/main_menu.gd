extends Control
var json

@onready var http_request = $HTTPRequest
@onready var mp3_request = $mp3_file_request


func _on_button_button_down() -> void:
	var url = $LineEdit.text
	url = url.split("=")[-1]
	print(url)
	var headers = ["Content-Type: application/json"]
	http_request.request("http://127.0.0.1:8000/song/" + url, headers, HTTPClient.METHOD_GET, url)
	
	


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedByteArray, body: PackedByteArray) -> void:
	json = JSON.parse_string(headers.get_string_from_utf8())
	global.json=json
	mp3_request.request("http://127.0.0.1:8000/download/file")
	
	print(json)
	


func _on_mp_3_file_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var save_path = "user://song_file.mp3"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_buffer(body)
		file.close()
		print("saved the song")
	get_tree().change_scene_to_file("res://maps/custom_level.tscn")


func _on_button_2_button_down() -> void:
	get_tree().change_scene_to_file("res://maps/tutorial.tscn")
