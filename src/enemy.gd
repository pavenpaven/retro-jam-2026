extends Node2D

signal attack
var map_cords
var id
var dead = false
var is_shark = false
@onready var anim = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = randi()
	if is_shark:
		anim.play("shark")
	else:
		anim.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Globals.to_real_cords(map_cords)
	var	map = get_parent().map
	if map[map_cords]["type"] == "fire" and not is_shark:
		anim.play("seagulldie")
		var dead = true
		
	

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
			if not is_shark or get_parent().allowed(map_cords + i, true):
				min_distance = dist
				best_move = i

	#TODO check if allowed
	print(dead)
	if not dead:
		if min_distance == 0:
			attack.emit()
			if is_shark:
				anim.play("sharkattack")
		else:
			map_cords += best_move


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_shark:
		anim.play("shark")
	else:
		var ind
		var n = 0
		for i in get_parent().enemies:
			if i.id == id:
				ind = n
			n+=1
		get_parent().enemies.remove_at(ind)
		queue_free()
