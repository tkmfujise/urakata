@tool
extends EditorPlugin

const REPL = preload("res://addons/urakata/src/repl/repl.tscn")

var repl : Control


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	repl = REPL.instantiate()
	var panel = Urakata.get_output_panel()
	if panel: panel.add_child(repl)


func _exit_tree() -> void:
	if repl: repl.queue_free()
