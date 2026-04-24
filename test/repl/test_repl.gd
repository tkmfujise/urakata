extends GutTest

var Scene = preload("res://addons/urakata/src/repl/repl.tscn")
var scene = null


func before_each():
	scene = Scene.instantiate()


func test_ready():
	assert_not_null(scene)
