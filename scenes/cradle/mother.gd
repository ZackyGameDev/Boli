extends Sprite2D

@onready var voice: AudioStreamPlayer2D = $AudioStreamPlayer2D

var bob_time := 0.0
var bobbing := false
var bob_amp := 6.0
var bob_speed := 5.0

var offscreen_x := -200.0
var center_x := 0.0

signal dia_got(res)
signal done_speaking(res)

var have_to_speak = false
var to_speak = null

func _ready() -> void:
	Network.response_ready.connect(_tasks_processed)
	

func perform_dialogue():
	center_x = get_viewport_rect().size.x * 0.5

	await move_to(center_x)
	while not have_to_speak:
		await get_tree().create_timer(0.1).timeout
		continue
	speak_last_network_line()
	#await speak_last_network_line()
	await done_speaking
	await paper_flip()
	await move_to(offscreen_x)
	
	
func move_to(target_x: float) -> void:

	var tween = create_tween()
	bobbing = true

	tween.tween_property(self, "position:x", target_x, 8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	bobbing = false
	position.y = round(position.y)
	
	
func _process(delta):

	if bobbing:
		bob_time += delta * bob_speed
		position.y += sin(bob_time) * bob_amp * delta * 60
	
func speak_last_network_line():
	
	if to_speak == null:
		print("no dialogue")
		return

	var b64:String = to_speak["npc_response"]["audio_base64"]
	var bytes:PackedByteArray = Marshalls.base64_to_raw(b64)
	var stream = AudioStreamWAV.load_from_buffer(bytes)

	if stream == null:
		print("Audio decode failed")
		return

	print("playing audio...")
	voice.stream = stream
	voice.seek(0)
	voice.play()

	await voice.finished
	print("finished audio..")
	done_speaking.emit(to_speak)
	to_speak = null
	have_to_speak = false
	
	
func paper_flip():

	var tween = create_tween()

	tween.tween_property(self, "scale:x", 0.0, 0.18)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

	await tween.finished

	flip_h = !flip_h

	var tween2 = create_tween()
	tween2.tween_property(self, "scale:x", 1.0, 0.18)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	await tween2.finished


func _on_voice_speech_received(_text: Variant) -> void:
	perform_dialogue()

func _tasks_processed() -> void:
	var res = null
	for data in Network.response_queue:
		if data.has("npc_response"): # that means its the relevant one
			res = data
			Network.response_queue.clear()
			break
	if res == null:
		return
	else:
		dia_prep(res)

func dia_prep(res):
	print(res["npc_response"]["translation"])
	have_to_speak = true
	to_speak = res
