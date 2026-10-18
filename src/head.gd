extends Node2D

@onready var invictimer = $Invincibility
@onready var eelhurtdelay = $EelHurtDelay
@onready var eelhurtsfx = $eelhurt
@onready var starsfx    = $starsfx
@onready var eelbabysfx = $eelbebis
@onready var mousecooldown = $MouseCooldown

var is_invicible = false
var map_cords = Vector2(5,5)
var tail      = [Vector2(3,2),Vector2(3,3), Vector2(3,4), Vector2(4,4),Vector2(5,4)]
var mouse_on_delay = false

var old_tail_pos = tail[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Globals.to_real_cords(map_cords)

func travel():
	tail.append(map_cords)
	tail.remove_at(0)

func on_starpickup():
	if not tail[0] == old_tail_pos:
		tail = [old_tail_pos] + tail
	starsfx.play()

func on_damage():
	if not is_invicible:
		tail.remove_at(0)
		is_invicible = true
		invictimer.start()
	eelhurtdelay.start()

func on_enemy_touch():
	on_damage()

func try_walk(dir, ismouse = false):
	if not mouse_on_delay or not ismouse:
		if ismouse:
			mousecooldown.start()
			mouse_on_delay = true
		var new_pos = map_cords + dir
		if not new_pos in tail.slice(1) and not dir == Vector2(0,0) and get_parent().allowed(new_pos):
			old_tail_pos = tail[0]
			travel()
			map_cords = new_pos
	
func _input(event):
	if event is InputEventKey and event.pressed:
		var vec = Vector2(0, 0)
		if event.keycode in [KEY_W, KEY_U]:
			vec = Vector2(0, -1)
		if event.keycode in [KEY_E, KEY_I]:
			vec = Vector2(1, -1)
		if event.keycode in [KEY_D, KEY_L]:
			vec = Vector2(1, 0)
		if event.keycode in [KEY_X, KEY_M]:
			vec = Vector2(0, 1)
		if event.keycode in [KEY_Z, KEY_N]:
			vec = Vector2(-1, 1)
		if event.keycode in [KEY_A, KEY_H]:
			vec = Vector2(-1, 0)
		try_walk(vec)
			

func _on_invincibility_timeout() -> void:
	is_invicible = false


func _on_eel_hurt_delay_timeout() -> void:
	eelhurtsfx.play()


func _on_mouse_cooldown_timeout() -> void:
	mouse_on_delay = false
