extends GutTest

var Scene = preload("res://addons/urakata/src/repl/repl.tscn")
var scene = null


func before_each():
	scene = Scene.instantiate()
	scene.change_mode(scene.modes[0])


func get_prompt_text() -> String:
	return scene.get_node('%Prompt').text


func test_ready():
	assert_not_null(scene)
	assert_ne(scene.modes.size(), 0)
	assert_not_null(scene.current_mode)


func test_append_input_history():
	assert_eq(scene.input_histories.size(), 0)
	scene._append_input_history('1')
	assert_eq(scene.input_histories.size(), 1)


func test_set_input_from_history_if_empty():
	scene._set_input_from_history(-1)
	assert_eq(get_prompt_text(), '')
	scene._set_input_from_history(1)
	assert_eq(get_prompt_text(), '')


func test_set_input_from_history_if_any():
	scene._append_input_history('1')
	scene._append_input_history('2')
	scene._set_input_from_history(1)
	assert_eq(get_prompt_text(), '2')
	scene._set_input_from_history(1)
	assert_eq(get_prompt_text(), '1')
	scene._set_input_from_history(1)
	assert_eq(get_prompt_text(), '')
	scene._set_input_from_history(-1)
	assert_eq(get_prompt_text(), '1')
	scene._set_input_from_history(-1)
	assert_eq(get_prompt_text(), '2')
	scene._set_input_from_history(-1)
	assert_eq(get_prompt_text(), '')
