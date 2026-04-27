@tool
extends RefCounted

var target : Variant

func _init(object: Variant) -> void:
	target = object


# TODO
func format() -> String:
	var text := "[b]%s[/b]\n" % type_name()
	return text


func type_name() -> String:
	match typeof(target):
		TYPE_OBJECT:
			if str(target).contains('<GDScriptNativeClass'):
				return 'Object'
			else: return target.get_class()
		_: return type_string(typeof(target))
