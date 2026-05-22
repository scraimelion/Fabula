extends Node

var game_start = false
var game_over = false
var game_quit = false
var is_archer = true
var can_move = true
var initial_stage = true
var in_static_cam = false
var final_stage = false
var current_static_cam : int = 0

var mouse_relative = Vector2()
var max_conv : int = 2

func change_chara ():
	initial_stage = false # Solo para marcar que el juego ya pasado su fase inicial
	is_archer = not is_archer

func stop_movement ():
	can_move = false

func start_movement ():
	can_move = true

func cam_switch_to_static(num_cam: int):
	in_static_cam = true
	current_static_cam = num_cam
	return

func cam_switch_to_chara(num_cam: int):
	in_static_cam = false

func start_final_stage():
	final_stage = true

func game_is_over():
	game_over = true
