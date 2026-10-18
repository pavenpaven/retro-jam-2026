extends Node

var tile_tex
var head_tex  = []
var body_tex  = []
var tails_tex = []
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_tex = load("res://Assets/Images/empty_hexagon.PNG")
	for i in range(1,7):
		head_tex.append(load("res://Assets/Images/eel/eelhead" + str(i) + ".PNG"))

	for i in range(1,7):
		body_tex.append(load("res://Assets/Images/eel/eelbody" + str(i) + ".PNG"))
		
	for i in range(1,7):
		tails_tex.append(load("res://Assets/Images/eel/eeltail" + str(i) + ".PNG"))

var sidelength = 32
func to_real_cords(cords):
	var a = (cords.y * Vector2(1, sqrt(3))/2 + Vector2(0, 0.35)) * sidelength
	var b = (cords.x * Vector2(1, 0)) * sidelength
	return (a + b)
