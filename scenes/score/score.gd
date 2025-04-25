extends Resource
class_name Score

var score : int = 0 : set = _set_score

func save() -> void:
	
	return

func _set_score(value : int) -> void:
	score = value
	return
