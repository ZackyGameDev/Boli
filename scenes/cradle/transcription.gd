extends RichTextLabel


func _on_voice_speech_received(speech_text: Variant) -> void:
	text = speech_text


func _on_voice_button_activated(data: Variant) -> void:
	text = "Recording..."
