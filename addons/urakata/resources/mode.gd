@tool
extends Resource
class_name UrakataMode

@export var label : String
@export var emoji : String
@export var color : Color
@export var character : String
@export var default : bool = false


func bbcode() -> String:
	return "%s\n[b][color=%s]%s>[/color][/b]" % [emoji, color_str(), label]


func matched(key: InputEventKey) -> bool:
	if not character or key.unicode == 0: return false
	return character == char(key.unicode)


func color_str() -> String:
	return '#' + color.to_html(false)
