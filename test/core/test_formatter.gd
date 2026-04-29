extends GutTestMeta

var formatter = null


func describe(target):
	formatter = Urakata.Formatter.new(target)


func perform() -> String:
	return formatter.perform()


func test_perform_arr():
	describe([1, '2', true])
	assert_not_empty(perform())


func test_perform_dictionary():
	describe({ 'foo': 1, 'bar': [2, 3] })
	assert_not_empty(perform())
