@tool
extends RefCounted

var target : Variant


func _init(object: Variant) -> void:
	target = object


func perform() -> String:
	match typeof(target):
		TYPE_DICTIONARY: return _perform_dictionary()
		TYPE_ARRAY: return _perform_array()
		_: return ''


func _perform_array() -> String:
	var arr = target.map(func(s):
		return "[cell padding=20,5,20,5][color=blue]%s[/color][/cell]" % s)
	var max_length = arr.map(func(s):
		return Urakata.bbcode_free_length(s)).max()
	var row_count =Urakata.max_output_length() / max_length
	return "[table=%s]%s[/table]" % [row_count, ''.join(arr)] 


func _perform_dictionary() -> String:
	var content := ''.join(target.keys().map(func(s):
		return "[cell][color=blue]%s[/color]: %s[/cell]" \
			% [s, target[s]]))
	var row_count = 1
	return "[table=%s]%s[/table]" % [row_count, content]
