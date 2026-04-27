extends GutTestMeta

var describer = null


func describe(target):
	describer = Urakata.Describer.new(target)


func format() -> String:
	return describer.format()


func test_format_int():
	describe(1)
	assert_not_empty(format())


func test_format_string():
	describe('test')
	assert_not_empty(format())


func test_format_native_object_class():
	describe(Node)
	assert_not_empty(format())


func test_format_native_object_instance():
	var ref = RefCounted.new()
	describe(ref)
	assert_not_empty(format())


func test_format_user_defined_object_class():
	describe(Urakata)
	assert_not_empty(format())


func test_format_user_defined_object_instance():
	var ref = UrakataCodeMode.new()
	describe(ref)
	assert_not_empty(format())
