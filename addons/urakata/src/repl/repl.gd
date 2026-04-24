@tool
extends HBoxContainer

@export var modes : Array[UrakataMode]
var current_mode : UrakataMode


func _ready() -> void:
	_set_syntax_highligher()
	change_mode(_default_mode())
	$Prompt.gui_input.connect(_prompt_input)


func submit() -> void:
	%Prompt.accept_event()
	var text = %Prompt.text
	if not text: return
	print_rich('%s %s' % [current_mode.prompt_prefix(), text])
	clear_prompt()
	print_rich('=> %s\n' % current_mode.perform(text))


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


func change_mode(mode: UrakataMode) -> void:
	current_mode = mode
	%Indicator.text = mode.indicator()


func _default_mode() -> UrakataMode:
	return modes[0]


# Set the highlighter only in the editor
# to prevent erors during Gut testing.
func _set_syntax_highligher() -> void:
	if Engine.is_editor_hint():
		$Prompt.syntax_highlighter = GDScriptSyntaxHighlighter


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
			
