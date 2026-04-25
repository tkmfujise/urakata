extends GutTest

var mode = null
var result = null


func before_each():
	mode = UrakataCodeMode.new()
	result = null


func perform(text: String):
	return mode.perform(text)


func execute(text: String):
	result = mode.execute(text)


func test_perform_reload():
	assert_eq(perform('reload!'), 'Reloaded.')


func test_execute_literal_number():
	execute('1')
	assert_eq(result, 1)


func test_execute_liternal_string():
	execute('"test"')
	assert_eq(result, 'test')


func test_perform_literal_number():
	assert_eq(perform('1'), '=> 1')


func test_perform_liternal_string():
	assert_eq(perform('"test"'), '=> test')


func test_execute_number_add():
	execute('1 + 1')
	assert_eq(result, 2)


func test_execute_builtin_method_call():
	execute('cos(0)')
	assert_eq(result, 1)


func test_execute_unknow_variable():
	execute('x + 1')
	assert_engine_error('Error')


func test_execute_define_variable():
	execute('var x = 1')
	execute('x + 1')
	assert_eq(result, 2)


func test_perform_define_variable():
	perform('var y = 1')
	assert_eq(perform('y + 1'), '=> 2')


func test_execute_unknow_function():
	execute('foo()')
	assert_engine_error('Error')


func test_execute_define_function():
	execute("""
func foo() -> String:
	return 'foo!'
""".strip_edges())
	execute('foo()')
	assert_eq(result, 'foo!')


func test_perform_define_function():
	perform("""
func bar() -> String:
	return 'bar!'
""".strip_edges())
	assert_eq(perform('bar()'), '=> bar!')
