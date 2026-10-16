extends Node2D

var map_cords = Vector2(5,5)
var tail      = [Vector2(4,4),Vector2(5,4)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Globals.to_real_cords(map_cords)

func travel():
	tail.append(map_cords)
	tail.remove_at(0)
	
func _input(event):
	if event is InputEventKey and event.pressed:
		var vec = Vector2(0, 0)
		if event.keycode == KEY_W:
			vec = Vector2(0, -1)
		if event.keycode == KEY_E:
			vec = Vector2(1, -1)
		if event.keycode == KEY_D:
			vec = Vector2(1, 0)
		if event.keycode == KEY_X:
			vec = Vector2(0, 1)
		if event.keycode == KEY_Z:
			vec = Vector2(-1, 1)
		if event.keycode == KEY_A:
			vec = Vector2(-1, 0)
		var new_pos = map_cords + vec
		if not new_pos in tail and not vec == Vector2(0,0):
			travel()
			map_cords = new_pos
