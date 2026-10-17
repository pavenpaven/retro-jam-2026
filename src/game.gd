extends Node2D

@onready var head = $Head
var map = {}
var map_sprites = {}
var tail_segs = []

func _ready():
	for i in range(10):
		for j in range(10):
			map[Vector2(i,j)] = {"Passable": true}

			var sprite = Sprite2D.new()
			map_sprites[Vector2(i,j)] = sprite
			sprite.position = Globals.to_real_cords(Vector2(i,j))
			sprite.texture = Globals.tile_tex
			add_child(sprite)

	for i in head.tail:
		var sprite = Sprite2D.new()
		tail_segs.append(sprite)
		sprite.texture = Globals.tails_tex[0]
		add_child(sprite)

func allowed(pos):		
	return true

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
			
