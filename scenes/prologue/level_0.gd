extends Node

@export var next_scene := "res://scenes/cradle/level1.tscn"

@onready var white := $White

func _ready():
	# white overlay starts hidden
	var c = white.modulate
	c.a = 0.0
	white.modulate = c
	white.visible = true

	await fade_sequence()
	await get_tree().create_timer(2.0).timeout

	# fade to white before switching
	await fade_in(white, 4.0)

	get_tree().change_scene_to_file(next_scene)


func fade_sequence():

	var nodes = [
		$"1",
		$"2",
		$"3",
		$"4",
		$"5"
	]

	# start invisible
	for n in nodes:
		var c = n.modulate
		c.a = 0.0
		n.modulate = c
		n.visible = true

	# fade one by one
	for n in nodes:
		await fade_in(n, 3.0)


func fade_in(node: CanvasItem, duration: float):
	var t = create_tween()
	t.tween_property(node, "modulate:a", 1.0, duration)
	await t.finished
