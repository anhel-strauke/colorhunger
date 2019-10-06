extends Camera

var move_speed: float = 5.0
var _target_pos = null


func _process(delta):
	if _target_pos != null and _target_pos != translation:
		#print("Moving cam ", translation, " -> ", _target_pos)
		var dir = (_target_pos - translation).normalized() * move_speed
		var delta_pos = dir * delta
		var new_pos = translation + delta_pos
		if delta_pos.length() > (_target_pos - translation).length():
			new_pos = _target_pos
			_target_pos = null
		translation = new_pos


func move_to(new_pos: Vector3):
	if new_pos != translation:
		_target_pos = new_pos