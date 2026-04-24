@tool
extends UrakataMode
class_name UrakataCodeMode


func perform(text: String) -> Variant:
	var expression = Expression.new()
	var err = expression.parse(text)
	if err != OK:
		printerr('Error: ', expression.get_error_text())
		return
	var result = expression.execute([], self)
	if expression.has_execute_failed(): return
	return result
