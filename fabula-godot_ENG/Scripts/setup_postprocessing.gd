extends Camera3D

@onready var postprocessing = $PostProcessing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	postprocessing.visible = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
