extends Node2D

@onready var head = $Head
var map = {}
var map_sprites = {}
var map_content_sprites = {}
var tail_segs = []
var enemies = []
@export var does_fire_extinguish_on_contact = true
var enemy_scene


var prop = 1.0

func _ready():
	var anim = load("res://Scenes/animated_sprite_2d.tscn")
	for i in range(-5, 15):
		for j in range(-1, 10):
			map[Vector2(i,j)] = {"type": "empty"}
			if randi() % 10 == 0:
				map[Vector2(i,j)] = {"type": "rock"}

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

	for i in range(8):
		map[Vector2(-i/2 - 1, i)] = {"type": "sand"}
		map[Vector2(-i/2 + 12, i)] = {"type": "sand"}
		
	for i in range(14):
		map[Vector2(i, -1)] = {"type": "sand"}
		map[Vector2(i - 5, -1 + 9)] = {"type": "sand"}

	map[Vector2(-3, 7)] = {"type": "rock"}
	map[Vector2(-3 + 11, 7)] = {"type": "rock"}
	for i in head.tail:
		var sprite = Sprite2D.new()
		tail_segs.append(sprite)
		sprite.texture = Globals.tails_tex[0]
		add_child(sprite)

	enemy_scene = load("res://Scenes/enemy.tscn")
	var enemy = enemy_scene.instantiate()
	enemy.map_cords = Vector2(1,1)
	enemy.attack.connect(head.on_enemy_touch)
	enemies.append(enemy)
	enemy.is_shark = true
	add_child(enemy)

func tile_sheet(tile):
	if tile["type"] == "star":
		if tile["timer"] > 0:
			return "starrise"
	return {"empty": "nothing"
		   ,"rock": "rock"
		   ,"fire": "fire"
		   ,"target":"target"
		   ,"star": "star"
		   ,"eelbaby":"eelbaby"
		   ,"sand":"sand"}[tile["type"]]


func allowed(pos, allow_player = false):
	if pos.y < 0 or pos.y >= 8: return false
	if (pos.y + 2*pos.x) < 1 : return false
	if (pos.y + 2*pos.x) >= 24: return false

	for i in enemies:
		if i.map_cords == pos:
			return false
	if not allow_player:
		for i in head.tail.slice(1) + [head.map_cords]:
			if i == pos:
				return false
	
	return not map[pos]["type"] in ["rock", "sand"]

func on_tick():
	for i in head.tail + [head.map_cords]:
		if map[i]["type"] in ["star"]:
			head.on_starpickup()
			map[i] = {"type": "empty"}
			
	for i in head.tail + [head.map_cords]:
		if map[i]["type"] in ["fire"]:
			head.on_damage()
			if does_fire_extinguish_on_contact:
				map[i] = {"type": "empty"}

		if map[i]["type"] == "eelbaby":
			map[i] = {"type": "empty"}
			Globals.score += 1
			print(Globals.score)
			

		

func orientation(v):
	var ind
	var n = 0
	for i in [Vector2(0,-1), Vector2(1, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0)]:
		if i == v:
			ind = n
		n+=1
	return ind

func _process(dt):
	on_tick()
	
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

	var numfire = 0.0
	for k in map_sprites:
		if map[k]["type"] == "star":
			map[k]["timer"] -= dt
		
		if map[k]["type"] == "fire":
			numfire+=1
			map[k]["timer"] -= dt
			if map[k]["timer"] <= 0:
				map[k] = {"type": "empty"}
				
				
		if map[k]["type"] == "target":
			numfire+=1
			map[k]["timer"] -= dt
			if map[k]["timer"] <= 0:
				map[k] = {"type": "fire", "timer": 6}
				
		
		map_content_sprites[k].animation = tile_sheet(map[k])
		map_content_sprites[k].play()

	handle_eel_baby()
	if numfire / (20*10) < (1 - prop):
		spawn()


func handle_eel_baby():
	var eel_baby_exists = false
	for k in map_sprites:
		if map[k]["type"] == "eelbaby":
			eel_baby_exists = true

	if not eel_baby_exists:
		var vec = random_position()
		map[vec] = {"type": "eelbaby"}
		
		
func random_position():
	var vec
	while true:
		var x = (randi() % 20) - 5
		var y = (randi() % 10)
		vec = Vector2(x, y)
		if allowed(vec):
			break
	if map[vec]["type"] == "empty":
		return vec
	return random_position()
			
func spawn():
	var x = (randi() % 20) - 5
	var y = (randi() % 10)
	var vec = Vector2(x,y)
	if map[vec]["type"] == "empty":
		map[vec] = {"type": "target", "timer": 3}
		

func _on_timer_timer_timeout() -> void:
	prop = prop * (1 - 0.005)

	
func _on_enemy_tick_timeout() -> void:
	for i in enemies:
		i.on_tick(head)


func _on_starspawn_timeout() -> void:
	var pos = random_position()
	map[pos] = {"type": "star", "timer": 0.3}


func _on_seagull_timeout() -> void:
	var pos = random_position()
	var enemy = enemy_scene.instantiate()
	enemy.map_cords = pos
	enemy.attack.connect(head.on_enemy_touch)
	enemy.is_shark = false
	enemies.append(enemy)
	add_child(enemy)
