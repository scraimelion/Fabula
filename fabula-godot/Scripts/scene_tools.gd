@tool
extends Node3D

@onready var archer = $FPSArcher
@onready var archer_cam = $FPSArcher/PhantomCamera3D
@onready var cam_list_parent = $Entorno/Ciudad/CamsCiudad
@onready var ciudad_fantasia = $Entorno/Cumulo/CiudadFantasia

@export var max_conv : int = 4
@export var start_final_stage : bool = false
@export var start_como_veska : bool = false

var cam_list : Array
var ciudad_fantasia_list : Array


func _ready() -> void:
	# Establecemos prioridades de todas las cámaras
	# Empezamos en cámara 0
	cam_list = cam_list_parent.get_children()
	for cam in cam_list:
		cam.set_priority(0)
	
	ciudad_fantasia_list = ciudad_fantasia.get_children()
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	# Setear herramientas de debug
	Global.initial_stage = not start_final_stage
	
	if start_como_veska:
		Global.change_chara()

func _input(_event) -> void:
	if not Engine.is_editor_hint():
		if Input.is_key_pressed(KEY_ESCAPE): # escape para salir
			get_tree().quit()

func _process(_delta: float) -> void:
	# DEBUG DRAW
	if Engine.is_editor_hint():
		DebugDraw3D.draw_cylinder_ab(archer.global_position, archer.global_position + Vector3(0,1,0), 
			Vector3(archer_cam.global_position - archer.global_position).length())

	if not Engine.is_editor_hint():
		if Global.in_static_cam:
			cam_list[Global.current_static_cam].set_priority(20)
		else:
			for cam in cam_list:
				cam.set_priority(0)
		
		
func _on_dialogic_signal(arg: String):
	match arg:
		"Final_stage_pillars":
			ciudad_fantasia_list[0].set_visible(true)
			pass
		"Final_stage_end_delulu":
			for ciudad in ciudad_fantasia_list:
				ciudad.set_visible(false)
			pass
