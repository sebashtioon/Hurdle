extends Node



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Quit") and OS.is_debug_build():
		get_tree().quit()
