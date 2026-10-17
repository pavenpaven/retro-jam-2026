extends Node2D

signal attack
var map_cords
@onready var anim = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Globals.to_real_cords(map_cords)
	

func on_tick(head):
	var nearest_sofar 
	var current_min = 1000
	for i in head.tail + [head.map_cords]:
		var dist = (Globals.to_real_cords(i) - position).length()
		if dist < current_min:
			current_min = dist
			nearest_sofar = i

	var direction = nearest_sofar - map_cords
	var best_move
	var min_distance = 10000
	for i in [Vector2(0,-1), Vector2(1, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0)]:
		var dist = (direction - i).length()
		if dist < min_distance:
			min_distance = dist
			best_move = i

	#TODO check if allowed
	if min_distance == 0:
		attack.emit()
	else:
		map_cords += best_move
