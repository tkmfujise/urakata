@tool
extends UrakataMode
class_name UrakataShellMode


func perform(text: String) -> Variant:
	var arr = text.split(' ')
	var results = []
	OS.execute(arr[0], arr.slice(1), results)
	return ''.join(results).strip_edges()
