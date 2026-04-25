@tool
extends HBoxContainer

@export var modes : Array[UrakataMode]
var current_mode : UrakataMode
var input_histories : Array[InputHistory]
var history_back_idx := 0


class InputHistory:
	var mode : UrakataMode
	var input : String


func _ready() -> void:
	change_mode(_default_mode())
	$Prompt.gui_input.connect(_prompt_input)


func submit() -> void:
	%Prompt.accept_event()
	var text = %Prompt.text.strip_edges()
	if not text: return
	print_rich('%s %s' % [current_mode.prompt_prefix(), text])
	clear_prompt()
	_append_input_history(text)
	print_rich('%s\n' % current_mode.perform(text))


func linebreak() -> void:
	%Prompt.start_action(TextEdit.ACTION_TYPING)
	%Prompt.insert_text_at_caret("\n")


func clear_prompt() -> void:
	%Prompt.clear()


func remove_following_text() -> void:
	var idx = %Prompt.get_caret_line()
	%Prompt.remove_text(
		idx,
		%Prompt.get_caret_column(),
		idx,
		%Prompt.get_line(idx).length())


func history_back() -> void:
	_set_input_from_history(1)
	call_deferred('_move_prompt_caret_last')


func history_forward() -> void:
	_set_input_from_history(-1)
	call_deferred('_move_prompt_caret_last')


func change_mode(mode: UrakataMode) -> void:
	current_mode = mode
	%Indicator.text = mode.indicator()


func _default_mode() -> UrakataMode:
	return modes[0]


func _append_input_history(text: String) -> void:
	var record = InputHistory.new()
	record.mode = current_mode
	record.input = text
	input_histories.push_back(record)


func _set_input_from_history(direction: int) -> void:
	history_back_idx += direction
	var count = input_histories.size()
	if history_back_idx < 1:
		history_back_idx = 0
		%Prompt.text = ''
	elif count < history_back_idx:
		history_back_idx = count + 1
		%Prompt.text = ''
	else:
		var record = input_histories.get(count - history_back_idx)
		change_mode(record.mode)
		%Prompt.text = record.input


func _move_prompt_caret_last() -> void:
	var l_idx = %Prompt.get_line_count()
	var c_idx = %Prompt.get_line(l_idx - 1).length()
	%Prompt.set_caret_line(l_idx)
	%Prompt.set_caret_column(c_idx)


func _prompt_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed): return
	var k := event as InputEventKey
	match k.keycode:
		KEY_ENTER:
			if k.shift_pressed: linebreak()
			else: submit()
		KEY_K:
			if k.ctrl_pressed: remove_following_text()
		KEY_L:
			if k.ctrl_pressed: Urakata.clear_output()
		KEY_U:
			if k.ctrl_pressed: clear_prompt()
		KEY_UP:
			if %Prompt.get_line_count() == 1:
				history_back()
		KEY_DOWN:
			if %Prompt.get_line_count() == 1:
				history_forward()
		_:
			if not k.ctrl_pressed and %Prompt.text.is_empty():
				if k.keycode == KEY_BACKSPACE:
					change_mode(_default_mode())
				else:
					var found = modes.filter(func(m):
						return m.matched(k))
					if found:
						change_mode(found[0])
						accept_event()
			
