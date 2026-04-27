@tool
extends Node3D

@onready var archer = $FPSArcher
@onready var archer_cam = $FPSArcher/PhantomCamera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# DEBUG DRAW
	if Engine.is_editor_hint():
		DebugDraw3D.draw_cylinder_ab(archer.global_position, archer.global_position + Vector3(0,1,0), 
			Vector3(archer_cam.global_position - archer.global_position).length())

	if not Engine.is_editor_hint():
		pass
