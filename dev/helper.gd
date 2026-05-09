@tool
extends EditorScript
class_name Helper


static func current() -> Node:
	return EditorInterface.get_edited_scene_root()


func hello():
	return 'Hello gdscript!'


func greet() -> Variant:
	return "Ciao come stai?"
