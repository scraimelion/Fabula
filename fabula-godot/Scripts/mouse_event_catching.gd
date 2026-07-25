extends SubViewportContainer

# Esto está feo de mil maneras diferentes pero funciona c:
# No te enfades conmigo en el futuro si te da problemas
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Global.mouse_relative = event.relative

func _process(delta: float) -> void:
	Global.mouse_relative = Vector2()
