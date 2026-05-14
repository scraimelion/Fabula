extends Node3D

@onready var cloud_mesh = $Cumulo_mball/Mball_065
@onready var collider = $Area3D

var impactada = false
var velocidad = 0.0
var continuar_caida = false

@export var aceleracion : float = 0.01
@export var max_caida : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if impactada:
		#cloud_mesh.get_surface_override_material(0).albedo_color = Color(0,0,0,1)
		cloud_mesh.get_surface_override_material(0).emission_enabled = false
		velocidad += aceleracion
		if position.y > max_caida * -1:
			position.y -= velocidad;
		elif Global.initial_stage:
			Global.game_over = true
		else:
			Dialogic.start_timeline("final_stage_TL")
			impactada = false

	if continuar_caida:
		velocidad += aceleracion
		if position.y > 250 * -1:
			position.y -= velocidad;
		else:
			Global.game_over = true

func _on_area_3d_cloud_hit() -> void:
	impactada = true
	pass # Replace with function body.
	
func _on_dialogic_signal(arg: String):
	match arg:
		"Cloud_continue_fall":
			continuar_caida = true
			pass
	return
