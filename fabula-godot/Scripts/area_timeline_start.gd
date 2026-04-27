extends Area3D

@export var timeline = "start_timeline"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	Global.stop_movement()
	Dialogic.start(timeline)
