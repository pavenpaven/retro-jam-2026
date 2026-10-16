extends Node2D

var map = {}
var map_sprites = {}

func _ready():
	for i in range(10):
		for j in range(10):
			map[Vector2(i,j)] = {"Passable": true}

			var sprite = Sprite2D.new()
			map_sprites[Vector2(i,j)] = sprite
			sprite.position = Globals.to_real_cords(Vector2(i,j))
			sprite.texture = Globals.tile_tex
			add_child(sprite)

func _process(dt):
	pass
			
