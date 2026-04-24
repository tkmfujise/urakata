extends GutTest

var mode = null
var result = null


func before_each():
	mode = UrakataCodeMode.new()
	result = null


func perform(text: String):
	result = mode.perform(text)


func test_perform_literal_number():
	perform('1')
	assert_eq(result, 1)


func test_perform_liternal_string():
	perform('"test"')
	assert_eq(result, 'test')


func test_perform_number_add():
	perform('1 + 1')
	assert_eq(result, 2)


func test_perform_builtin_method_call():
	perform('cos(0)')
	assert_eq(result, 1)


func test_perform_unknow_variable():
	perform('x + 1')
	assert_engine_error('Error')


func test_perform_define_variable():
	perform('var x = 1')
	perform('x + 1')
	assert_eq(result, 2)


func test_perform_unknow_function():
	perform('foo()')
	assert_engine_error('Error')


func test_perform_define_function():
	perform("""
func foo() -> String:
	return 'foo!'
""".strip_edges())
	perform('foo()')
	assert_eq(result, 'foo!')
