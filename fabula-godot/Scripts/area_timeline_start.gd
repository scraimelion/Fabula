extends Area3D

@export var timeline = "default_timeline"
@export var can_reenter = false
@export var is_critical_path = false

var entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
		
	if not entered and is_critical_path:
		Dialogic.VAR.critical_path += 1
	
	if not entered or can_reenter:
		Dialogic.start(timeline)
		
		entered = true
