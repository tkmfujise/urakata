@tool
extends Node
class_name Urakata


static func version() -> String:
	var config = ConfigFile.new()
	var err = config.load("res://addons/urakata/plugin.cfg")
	if err == OK:
		return 'v' + config.get_value('plugin', 'version')
	else: return ''


static func get_output_panel() -> Node:
	var output_panel = null
	var editor_log := find_editor_class('EditorLog')
	if editor_log:
		var container := editor_log.get_child(-1)
		if container:
			output_panel = container.get_child(0)
	if not output_panel:
		printerr('EditorLog class is not found.')
		return
	return output_panel


static func clear_output() -> void:
	var panel := get_output_panel()
	if panel:
		var output := panel.get_child(0)
		if output: output.clear()


static func find_editor_class(klass_name: String, root: Node = null) -> Node:
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
