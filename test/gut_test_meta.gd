extends GutTest
class_name GutTestMeta


func before_all():
	Urakata.running_test = true


func after_all():
	Urakata.running_test = false


func assert_not_empty(val: Variant):
	match typeof(val):
		TYPE_STRING: assert_ne(val, '')
		TYPE_ARRAY:  assert_ne(val, [])
		_:  assert_not_null(val)
