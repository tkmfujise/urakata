@tool
extends EditorScript
class_name Helper


func current() -> Node:
	return get_scene()

func hello():
	return 'Hello gdscript!'



func find_editor_log() -> Node:
	return find_editor_class('EditorLog')


func find_editor_class(klass_name: String, root: Node = null) -> Node:
	if not root:
		root = EditorInterface.get_base_control()
	var node: Node = null
	if root.get_class() == klass_name:
		node = root
	else:
		for child in root.get_children():
			node = find_editor_class(klass_name, child)
			if node: break
	return node
