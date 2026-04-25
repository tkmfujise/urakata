@tool
extends UrakataMode
class_name UrakataShellMode


func perform(text: String) -> Variant:
	var arr = text.split(' ')
	var results = []
	var err = OS.execute(arr[0], arr.slice(1), results, true)
	if err != OK:
		printerr(format_results(results))
		return ''
	return format_results(results)


func format_results(arr: Array) -> String:
	return ''.join(arr).strip_edges()
