extends Node

var tile_tex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_tex = load("Assets/Images/empty_hexagon.PNG")

var sidelength = 32
func to_real_cords(cords):
	var a = (cords.y * Vector2(1, sqrt(3))/2) * sidelength
	var b = (cords.x * Vector2(1, 0)) * sidelength
	return (a + b)
