@tool
extends UrakataMode
class_name UrakataCodeMode

const INIT_COMMAND = 'reload!'
const STATEMENT_KEYWORDS = [
	'var ', 'func '
]

var context : GDScript = null
var state : RefCounted = null
var statements : Array[String] = []


func _init() -> void:
	context = GDScript.new()
	statements = []


func perform(text: String) -> Variant:
	if text == INIT_COMMAND:
		statements = []
		return
	rebuild_state()
	if check_statement(text):
		try_statement(text)
		return null
	else:
		var result = try_expression(text)
		if result[0]:
			return result[1]
		else:
			return try_statement(text)


func check_statement(text: String) -> bool:
	return STATEMENT_KEYWORDS.any(
		func(k): return text.begins_with(k))


# return: [succeeded: bool, result: Variant]
func try_expression(text: String) -> Array:
	var expression = Expression.new()
	var err = expression.parse(text)
	if err != OK: return [false, null]
	var result = expression.execute([], state)
	if expression.has_execute_failed():
		return [false, null]
	return [true, result]


# TODO: don't append if error
func try_statement(text: String) -> Array:
	statements.push_back(text)
	return [true, null]


func rebuild_state() -> void:
	var src := ''
	for st in statements: src += st + "\n"
	context.source_code = src
	context.reload(true)
	state = context.new()
