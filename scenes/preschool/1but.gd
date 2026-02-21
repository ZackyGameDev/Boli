extends GUIButton

@export var npc: NodePath
@export var punjabi_word: String = "ਪਾਣੀ"
@export var line: String = "ਇਹ ਪਾਣੀ ਹੈ"
@export var outline: String = "Say something about offering to be friends."


func _ready() -> void: 
	super._ready()
	squish_amount = 1
	

func _on_button_activated(data: Variant) -> void:
	print("pressed")
	var n = get_node(npc)
	n.look_at_object(self, line)
	Network.request_dialogue(outline)
