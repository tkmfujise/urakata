@tool
extends RefCounted

const CELL_LENGTH = 700
var target : Variant


class Method:
	var name : String
	var args : Array[Argument]
	var return_type : String
	var is_static : bool

	func _init(dict: Dictionary) -> void:
		name = dict['name']
		args = []
		is_static = dict['flags'] >= METHOD_FLAG_STATIC
		for a in dict['args']:
			args.push_back(Argument.new(a))
		return_type = type_string(dict['return']['type']) \
			if dict['return']['type'] else \
			('Variant' if dict['return']['usage'] else 'void')

	func format() -> String:
		var args_formatted = ', '.join(args.map(func(a):
				return a.format()))
		return "[cell padding=20,5,20,5][color=blue][i]%s[/i][/color]%s %s(%s)[/cell]" \
				% [return_type,
				(' [color=blue]static[/color]' if is_static else ''),
				name,
				args_formatted]


class Argument:
	var name : String
	var klass : String
	var type : String

	func _init(dict: Dictionary) -> void:
		name = dict['name']
		klass = dict['class_name']
		type = type_string(dict['type']) \
			if dict['type'] else 'Variant'

	func format() -> String:
		return '%s: [color=blue]%s[/color]' % [name, (klass if klass else type)]


func _init(object: Variant) -> void:
	target = object


# TODO: Not woriking on EditorInterface or ProjectSettings
func format() -> String:
	var text := "[b]%s[/b]\n" % type_name()
	if typeof(target) == TYPE_OBJECT \
	and not is_gdscript_native_class():
		var arr := []
		var method_list = target.get_script_method_list() \
			if is_gdscript() else target.get_method_list()
		for m in method_list:
			if m['name'].begins_with('_'): continue
			if not m['id'] == 0: continue
			arr.push_back(Method.new(m).format())

		var max_length = arr.map(func(a): \
			return Urakata.bbcode_free_length(a)).max()
		text += '[table=%s]%s[/table]' % \
			[(Urakata.max_output_length() / (max_length)), ''.join(arr)]
	return text


func type_name() -> String:
	match typeof(target):
		TYPE_OBJECT:
			if is_gdscript_native_class(): return 'Object'
			else: return target.get_class()
		_: return type_string(typeof(target))


func is_gdscript_native_class() -> bool:
	return str(target).contains('<GDScriptNativeClass')


func is_gdscript() -> bool:
	return not is_gdscript_native_class() \
		and target.get_class() == 'GDScript'
