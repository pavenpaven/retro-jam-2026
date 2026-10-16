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
		print(i)
		var sprite = Sprite2D.new()
		tail_segs.append(sprite)
		sprite.texture = Globals.tail_tex
		sprite.scale = Vector2(0.2, 0.2)
		add_child(sprite)

func allowed(pos):		
	return true
		
func _process(dt):
	var n = 0
	for i in head.tail:
		tail_segs[n].position = Globals.to_real_cords(i)

		n+=1
			
