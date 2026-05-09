@tool
extends RefCounted
class_name Urakata

static var running_test : bool = false
static var Describer := preload("res://addons/urakata/src/core/describer.gd")
static var Formatter := preload("res://addons/urakata/src/core/formatter.gd")


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


static func output_panel_width() -> float:
	if running_test: return 2500.0
	var panel = get_output_panel()
	if not panel: return 0.0
	return panel.get_parent_area_size().x



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


static func max_output_length() -> int:
	if running_test: return 150
	var width := output_panel_width()
	var font_size = get_output_panel().get_theme_font_size('font_size')
	return int(width / (font_size * 0.6))


# bbcode_free_length('[color=red]test[/color]') # => 4
static func bbcode_free_length(raw_text: String) -> int:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var clean_text = regex.sub(raw_text, '', true)
	return clean_text.length()


static func describe(target: Variant, all: bool = false) -> void:
	print_rich(Describer.new(target).format(all))


static func format(target: Variant) -> void:
	print_rich(Formatter.new(target).perform())
