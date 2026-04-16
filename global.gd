extends Node

var json ={"1.72": "BS", "3.53": "MT"}
var current_obst = ""

var tutorial_json = {"3.93": "S", "5.94": "S", "7.51": "B", "9.57": "B", "11.71": "M", "13.68": "M", "17.80": "T", "15.74": "T", "19.86": "B", "21.92": "S", "24.88": "BT", "27.06": "BM", "29.14": "ST", "31.05": "MS", "34.27": "BM", "36.32": "BS", "38.39": "MT", "40.42": "ST"}
var character_state = "walk"
var timing_is_right = false
var song: PackedByteArray
