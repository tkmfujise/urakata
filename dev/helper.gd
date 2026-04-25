@tool
extends EditorScript
class_name Helper


func current() -> Node:
	return EditorInterface.get_edited_scene_root()


func hello():
	return 'Hello gdscript!'
