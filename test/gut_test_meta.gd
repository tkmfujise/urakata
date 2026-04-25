extends GutTest
class_name GutTestMeta


func before_all():
	Urakata.running_test = true


func after_all():
	Urakata.running_test = false
