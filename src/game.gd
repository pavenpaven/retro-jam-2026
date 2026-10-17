extends Node2D

@onready var head = $Head
@onready var timer = $Timer
var map = {}
var map_sprites = {}
var map_content_sprites = {}
var tail_segs = []

func _ready():
	var anim = load("res://Scenes/animated_sprite_2d.tscn")
	for i in range(-5, 15):
		for j in range(10):
			map[Vector2(i,j)] = {"type": "empty"}
			if randi() % 10 == 0:
				map[Vector2(i,j)] = {"type": "rock"}

			if randi() % 10 == 0:
				map[Vector2(i,j)] = {"type": "star"}

			var sprite = Sprite2D.new()
			map_sprites[Vector2(i,j)] = sprite
			sprite.position = Globals.to_real_cords(Vector2(i,j))
			sprite.texture = Globals.tile_tex
			add_child(sprite)

			var ani = anim.instantiate()
			ani.position = Globals.to_real_cords(Vector2(i,j))
			map_content_sprites[Vector2(i,j)] = ani
			add_child(ani)
			

			
			# Death to america
			# UVS är en terrororganisation

	for i in head.tail:
		var sprite = Sprite2D.new()
		tail_segs.append(sprite)
		sprite.texture = Globals.tails_tex[0]
		add_child(sprite)

func tile_sheet(tile):
	return {"empty": "nothing"
		   ,"rock": "rock"
		   ,"fire": "fire"
		   ,"target":"target"
		   ,"star": "star"}[tile["type"]]


func allowed(pos):		
	return not map[pos]["type"] in ["rock"]

func on_tick():
	for i in head.tail + [head.map_cords]:
		if map[i]["type"] in ["star"]:
			head.on_starpickup()
			map[i] = {"type": "empty"}
			
	for i in head.tail + [head.map_cords]:
		if map[i]["type"] in ["fire"]:
			head.on_damage()

		

func orientation(v):
	var ind
	var n = 0
	for i in [Vector2(0,-1), Vector2(1, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0)]:
		if i == v:
			ind = n
		n+=1
	return ind

func _process(dt):
	var n = 0

	if len(tail_segs) > len(head.tail):
		tail_segs[0].queue_free()
		tail_segs.remove_at(0)

	if len(tail_segs) < len(head.tail):
		var sprite = Sprite2D.new()
		tail_segs.append(sprite)
		sprite.texture = Globals.tails_tex[0]
		add_child(sprite)
	
	for i in head.tail: ## could update less often
		if n==0:
			tail_segs[0].position = Globals.to_real_cords(head.tail[1])
		if n > 0:
			tail_segs[n].position = Globals.to_real_cords(i)
			if n == 1:
				var vec = head.tail[0] - i
				var ind = [3,2,4,5,0,1][orientation(vec)]
				tail_segs[0].texture = Globals.tails_tex[ind]
			if n < len(head.tail) - 1:
				var vec = head.tail[n+1] - i
				var ind = [4,1,0,2,3,5][orientation(vec)]
				tail_segs[n].texture = Globals.body_tex[ind]
			else:
				var vec = head.map_cords - i
				var ind = [0,1,5,2,3,4][orientation(vec)]
				tail_segs[n].texture = Globals.head_tex[ind]
				
		n+=1

	for k in map_sprites:
		if map[k]["type"] == "fire":
			map[k]["timer"] -= dt
			if map[k]["timer"] <= 0:
				map[k] = {"type": "empty"}
				
		if map[k]["type"] == "target":
			map[k]["timer"] -= dt
			if map[k]["timer"] <= 0:
				map[k] = {"type": "fire", "timer": 6}
		
		map_content_sprites[k].animation = tile_sheet(map[k])
		map_content_sprites[k].play()
		


func _on_timer_timeout() -> void:
	var x = (randi() % 20) - 5
	var y = (randi() % 10)
	var vec = Vector2(x,y)
	if map[vec]["type"] == "empty":
		map[vec] = {"type": "target", "timer": 3}
		timer.wait_time *= 0.95
