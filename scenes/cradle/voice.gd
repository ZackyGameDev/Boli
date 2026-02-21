extends GUIButton

signal speech_received(text)
signal speech_error(reason)

var speech_js
var js_callback


func _ready():
	print("VERSION 0")
	
	super._ready()
	
	if not OS.has_feature("web"):
		return

	speech_js = JavaScriptBridge.get_interface("GodotSpeech")
	js_callback = JavaScriptBridge.create_callback(_on_js)

	speech_js.registerCallback(js_callback)


func _on_button_activated(_data):
	speech_js.startSpeechRecognition()


func _on_js(args):

	if args.is_empty():
		return

	var json_string : String = args[0]

	var json = JSON.parse_string(json_string)
	if typeof(json) != TYPE_DICTIONARY:
		return

	match json.type:

		"speech":
			speech_received.emit(json.text)

		"error":
			speech_error.emit(json.error)
