extends GutTestMeta


func test_version():
	assert_true(Urakata.version().begins_with('v'))


func test_bbcode_free_length_plan():
	assert_eq(Urakata.bbcode_free_length('test'), 4)


func test_bbcode_free_length_one_block():
	assert_eq(Urakata.bbcode_free_length(
		'[color=red]test[/color]'), 4)


func test_bbcode_free_length_nested_block():
	assert_eq(Urakata.bbcode_free_length(
		'[b][color=red]test[/color][/b]'), 4)
