extends Node

var game_start = false
var game_over = false
var game_quit = false
var is_archer = true
var can_move = true

var mouse_relative = Vector2()

func change_chara ():
	is_archer = not is_archer

func stop_movement ():
	can_move = false

func start_movement ():
	can_move = true
