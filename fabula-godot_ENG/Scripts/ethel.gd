extends Sprite3D

var spin = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(spin * delta)
	pass
