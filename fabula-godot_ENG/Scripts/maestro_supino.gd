extends MeshInstance3D

@onready var anims = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialogic_signal(arg: String):
	match arg:
		"supino_salir":
			visible = true
			pass
		"supino_avanza":
			anims.play("forward")
			pass
		"supino_rito":
			var stickman = load("res://Images/HabitantesCiudad/maestro_supino_alabando.png")
			get_active_material(0).albedo_texture = stickman
			pass
		"supino_rito_fin":
			var stickman = load("res://Images/HabitantesCiudad/maestro_supino.png")
			get_active_material(0).albedo_texture = stickman
			pass
