extends Node2D

@onready var pressed   = $ButtonTexPressed
@onready var unpressed = $ButtonTexUnpressed
@onready var label     = $Label
var inside = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "Score: " + str(Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	unpressed.z_index = 0
	pressed.z_index = 1


func _on_button_button_up() -> void:
	unpressed.z_index = 1
	pressed.z_index = 0
	if inside:
		Globals.score = 0
		print("change")
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
		queue_free()


func _on_button_mouse_entered() -> void:
	inside = true


func _on_button_mouse_exited() -> void:
	inside = false
	
