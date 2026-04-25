extends GutTestMeta

var mode = null
var result = null


func before_each():
	mode = UrakataShellMode.new()
	result = null


func perform(text: String):
	result = mode.perform(text)
	return result


func test_perform_ls():
	assert_not_empty(perform('ls'))


func test_perform_ls_with_args():
	assert_not_empty(perform('ls -lA'))
