@tool
extends UrakataMode
class_name UrakataCodeMode

const INIT_COMMAND = 'reload!'
const STATEMENT_KEYWORDS = [
	'var ', 'func '
]

var context : GDScript = null
var statements : Array[String] = []
var constants : Dictionary


func _init() -> void:
	context = GDScript.new()
	statements = []
	reset_constants()


func perform(text: String) -> Variant:
	if text == INIT_COMMAND:
		_init()
		return 'Reloaded.'
	else:
		return "=> %s" % str(execute(text))


func execute(text: String) -> Variant:
	reset_context()
	if check_statement(text):
		try_statement(text)
		return null
	else:
		var result = try_expression(text)
		if result[0]:
			return result[1]
		else:
			printerr(result[1])
			return null


func check_statement(text: String) -> bool:
	return STATEMENT_KEYWORDS.any(
		func(k): return text.begins_with(k))


# TODO: don't append if error
# return: [succeeded: bool, result: Variant]
func try_statement(text: String) -> Array:
	statements.push_back(text)
	return [true, null]


# return: [succeeded: bool, result: Variant]
func try_expression(text: String) -> Array:
	var expression := Expression.new()
	var dict := constants_with_utils()
	var err := expression.parse(text, dict.keys())
	if err != OK: return [false, expression.get_error_text()]
	var state := context.new()
	var result := expression.execute(dict.values(), state)
	if expression.has_execute_failed():
		return [true, eval(text)]
	else:
		return [true, result]


func eval(text: String) -> Variant:
	var src := "func __eval():\n\treturn (%s)" % text
	context.source_code += src
	var err := context.reload(true)
	if err == OK:
		var obj := context.new()
		return obj.__eval()
	else:
		return null


# CAUTION:
# If Gut tests access EditorInterface.get_edited_scene_root,
# it will trigger an engine error. To prevent this,
# set `Urakata.running_test` to true during testing.
func constants_with_utils() -> Dictionary:
	var dict := constants.duplicate()
	if not Urakata.running_test:
		dict.merge({
			'current': EditorInterface.get_edited_scene_root(),
		})
	return dict


func reset_constants() -> void:
	constants = {}
	for nm in Engine.get_singleton_list():
		constants[nm] = Engine.get_singleton(nm)
	for c in ProjectSettings.get_global_class_list():
		constants[c['class']] = load(c['path'])


func reset_context() -> void:
	var src := ''
	for st in statements: src += st + "\n"
	context.source_code = src
	context.reload(true)
