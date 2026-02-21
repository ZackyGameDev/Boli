extends Node2D

@onready var white := $White
@onready var end := $end

var running := false


func do_it():
	if running:
		return
	running = true

	await fade_from_hidden(white, 3.0)
	await fade_from_hidden(end, 2.5)

	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/preschool/level2.tscn")


func fade_from_hidden(node: CanvasItem, duration: float):
	node.visible = true
	
	var c = node.modulate
	c.a = 0.0
	node.modulate = c
	
	var t = create_tween()
	t.tween_property(node, "modulate:a", 1.0, duration)
	await t.finished
